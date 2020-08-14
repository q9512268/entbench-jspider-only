package net.javacoding.jspider.core.task.work;


import net.javacoding.jspider.api.model.HTTPHeader;
import net.javacoding.jspider.api.model.Site;
import net.javacoding.jspider.core.SpiderContext;
import net.javacoding.jspider.core.logging.LogFactory;
import net.javacoding.jspider.core.event.CoreEvent;
import net.javacoding.jspider.core.event.impl.*;
import net.javacoding.jspider.core.task.WorkerTask;
import net.javacoding.jspider.core.util.http.HTTPHeaderUtil;
import net.javacoding.jspider.core.util.URLUtil;
import net.javacoding.jspider.core.throttle.Throttle;

import java.io.*;
import java.net.*;


/**
 *
 * $Id: SpiderHttpURLTask.java,v 1.19 2003/04/10 16:19:14 vanrogu Exp $
 *
 * @author Günther Van Roey
 */
public class SpiderHttpURLTask@mode<?->X> extends BaseWorkerTaskImpl {

    protected URL url;
    protected Site site;

    mcase<int> HACK = mcase<int>{ low: 0; mid: 0; high: 0; };

    panda_attribute {
      if (site.getAllResources().length < 50) {
        return @mode<high>;
      } else if (site.getAllResources().length < 200) {
        return @mode<mid>;
      } else {
        return @mode<low>;
      }
    }

    panda_copy {
      SpiderHttpURLTask task = new SpiderHttpURLTask(this.context, this.url, this.site);
      return task;
    }

    public SpiderHttpURLTask(SpiderContext context, URL url, Site site) {
        super(context, WorkerTask.WORKERTASK_SPIDERTASK);
        this.url = url;
        this.site = site;
    }

    public void prepare() {
        // Sound due to resolution in AgentImpl
        Throttle@mode<*> throttle = context.throttle(site);
        throttle.throttle();
    }

    public void execute() {

        CoreEvent event = null;
        URLConnection connection = null;

        InputStream inputStream = null;

        int httpStatus = 0;
        HTTPHeader[] headers = null;

        try {

            connection = url.openConnection();

            if (connection instanceof HttpURLConnection) {
                ((HttpURLConnection) connection).setInstanceFollowRedirects(false);
            }

            connection.setRequestProperty("User-agent", site.getUserAgent());
            context.preHandle(connection, site);

            long start = System.currentTimeMillis();
            connection.connect();

            if (connection instanceof HttpURLConnection) {
                httpStatus = ((HttpURLConnection) connection).getResponseCode();
                switch (httpStatus) {
                    case HttpURLConnection.HTTP_MOVED_PERM:
                    case HttpURLConnection.HTTP_MOVED_TEMP:
                        String redirectURL = connection.getHeaderField("location");
                        notifyEvent(url, new URLFoundEvent(context, url, URLUtil.normalize(new URL(redirectURL))));
                        break;
                    default:
                        break;
                }
            }
            inputStream = new BufferedInputStream(connection.getInputStream());

            ByteArrayOutputStream os = new ByteArrayOutputStream();
            InputStream is = new BufferedInputStream(inputStream);
            //int size = connection.getContentLength();
            int size = 0;
            try {
                    int i = is.read();
                    while (i != -1) {
                        size++;
                        os.write(i);
                        i = is.read();
                    }
            } catch (IOException e) {
                LogFactory.getLog(SpiderHttpURLTask.class).error("i/o exception during fetch",e);
            }

            String contentType = connection.getContentType();
            int timeMs = (int) (System.currentTimeMillis() - start);

            headers = HTTPHeaderUtil.getHeaders(connection);

            if (httpStatus >= 200 && httpStatus < 303) {
                event = new URLSpideredOkEvent(context, url, httpStatus, connection, contentType, timeMs, size, os.toByteArray(), headers);
            } else {
                event = new URLSpideredErrorEvent(context, url, httpStatus, connection, headers, null);
            }

            context.postHandle(connection, site);

        } catch (FileNotFoundException e) {
            headers = HTTPHeaderUtil.getHeaders(connection);
            event = new URLSpideredErrorEvent(context, url, 404, connection, headers, e);
        } catch (Exception e) {
            LogFactory.getLog(this.getClass()).error("exception during spidering", e);
            event = new URLSpideredErrorEvent(context, url, httpStatus, connection, headers, e);
        } finally {
            notifyEvent(url, event);
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    LogFactory.getLog(SpiderHttpURLTask.class).error("i/o exception closing inputstream",e);
                }
            }
        }
    }

}

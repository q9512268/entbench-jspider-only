package net.javacoding.jspider.core.throttle.impl;


import net.javacoding.jspider.core.throttle.Throttle;
import net.javacoding.jspider.core.threading.WorkerThread; 

/**
 * Throttle implementation that forces at least x milliseconds between two
 * subsequent requests on a certain host.
 *
 * $Id: PandaLoadThrottleImpl.java,v 1.2 2003/02/27 16:47:50 vanrogu Exp $
 *
 * @author Günther Van Roey
 */
public class PandaLoadThrottleImpl@mode<?->X> implements Throttle@mode<X> {

    /** min. milliseconds between two subsequent calls. */
    protected mcase<int> milliseconds = mcase<int> {
      low: 1000;
      mid: 750;
      high: 250;
    };

    /** last allowed time for a fetch. */
    protected long lastAllow = -1;

    panda_attribute {
      if (PANDA_Util.Temperature.getTempC() <= 50.0) {
        return @mode<high>;
      } else if (PANDA_Util.Temperature.getTempC() <= 55.0) {
        return @mode<mid>;
      } else {
        return @mode<low>;
      }
    }

    /**
     * Constructor taking the amount of milliseconds to wait between
     * two subsequent requests as a parameter.
     * @param milliseconds minimum nr of milliseconds
     */
    public PandaLoadThrottleImpl(int milliseconds) {
    }

    /**
     * This method will block spider threads until they're allowed
     * to do a request.
     */
    public synchronized void throttle() {
    }
}


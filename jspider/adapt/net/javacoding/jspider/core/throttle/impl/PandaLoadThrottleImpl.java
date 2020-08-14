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
    public int milliseconds;

    panda_attribute {
      if (this.milliseconds <= 250) {
        return @mode<high>;
      } else if (this.milliseconds < 500) {
        return @mode<mid>;
      } else {
        return @mode<low>;
      }
    }

    /** last allowed time for a fetch. */
    protected long lastAllow = -1;
    
    /**
     * Constructor taking the amount of milliseconds to wait between
     * two subsequent requests as a parameter.
     * @param milliseconds minimum nr of milliseconds
     */
    public PandaLoadThrottleImpl(int milliseconds) {
      this.milliseconds = milliseconds;
      this.lastAllow = System.currentTimeMillis() - milliseconds;
    }

    /**
     * This method will block spider threads until they're allowed
     * to do a request.
     */
    public synchronized void throttle() {
        long thisTime = System.currentTimeMillis();
        long scheduledTime = lastAllow + milliseconds;

        if (scheduledTime > thisTime) {
            try {
                Thread.sleep(scheduledTime - thisTime);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }

        lastAllow = System.currentTimeMillis();
    }
}


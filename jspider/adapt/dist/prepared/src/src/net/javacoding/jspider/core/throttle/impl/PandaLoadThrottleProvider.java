package net.javacoding.jspider.core.throttle.impl;


import net.javacoding.jspider.core.throttle.Throttle;
import net.javacoding.jspider.core.throttle.ThrottleProvider;
import net.javacoding.jspider.core.util.config.PropertySet;
import net.javacoding.jspider.core.logging.LogFactory;
import net.javacoding.jspider.core.logging.Log;

public class PandaLoadThrottleProvider implements ThrottleProvider {

    public static final String INTERVAL = "interval";
    public static final int INTERVAL_DEFAULT = 1000;
    public static final int INTERVAL_MIN = 250;

    /**
     * Method that instantiates the Throttle implementation.
     * @return Throttle instance
     */
    public Throttle@mode<?> createThrottle(PropertySet props) {

        /* get the interval from the configuration. */
        String interval_val = System.getenv("PANDA_JSPIDER_INTERVAL");

        int interval = INTERVAL_DEFAULT;

        if (interval_val != null) {
          interval = Integer.parseInt(interval_val);
        }

        return new PandaLoadThrottleImpl@mode<?>(interval);
    }
}

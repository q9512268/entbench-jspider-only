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
        int interval = props.getInteger(INTERVAL, INTERVAL_DEFAULT);

        Log log = LogFactory.getLog(PandaLoadThrottleProvider.class);

        if (interval < INTERVAL_MIN) {
            log.warn("Throttle interval < " + INTERVAL_MIN + " ms is dangereous - set to minimum allowed of " + INTERVAL_MIN + " ms");
            interval = INTERVAL_MIN;
        }

        log.debug("throttle interval set to " + interval + " ms.");
        System.err.format("interval set at %d\n", interval);

        return new PandaLoadThrottleImpl@mode<?>(0);
    }
}

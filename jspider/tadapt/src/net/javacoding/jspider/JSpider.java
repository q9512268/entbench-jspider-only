package net.javacoding.jspider;


import net.javacoding.jspider.core.*;
import net.javacoding.jspider.core.impl.CLI;
import net.javacoding.jspider.core.util.config.ConfigurationFactory;

import java.net.URL;

import jrapl.EnergyCheckUtils;

modes {low <: mid; mid <: high; }

/**
 * Main startup class.
 *
 * $Id: JSpider.java,v 1.27 2003/04/10 16:19:03 vanrogu Exp $
 *
 * @author G�nther Van Roey
 * @todo support commandline input for proxy password
 * @todo implement Swing-based monitor UI ( threading, progress, ...)
 */
public class JSpider {

    protected Spider spider;
    protected SpiderContext context;

    // ANTHONY - Looks like Spider and SpiderContext are the main splits
    public JSpider ( URL baseURL ) throws Exception {
        SpiderNest nest = new SpiderNest();
        context = SpiderContextFactory.createContext(baseURL);
        spider = nest.breedSpider(context);
    }

    public void start ( ) throws Exception {
        spider.crawl(context);
    }

    public SpiderContext getContext() {
        return context;
    }

    public static void main(String[] args) throws Exception {

        CLI.printSignature();

        if (args.length != 1 && args.length != 2 ) {
            System.out.println("Usage: JSpider baseURL [config]");
            return;
        }

        if (args.length > 1) {
            ConfigurationFactory.getConfiguration(args[1]);
        } else {
            ConfigurationFactory.getConfiguration();
        }

        PANDA_Util.initModeFile();
        PANDA_Util.startStopwatch();
        double[] before = EnergyCheckUtils.getEnergyStats();

        URL baseURL = new URL(args[0]);

        JSpider jspider = new JSpider ( baseURL );
        jspider.start ( );

        double[] after = EnergyCheckUtils.getEnergyStats();
        PANDA_Util.stopStopwatch();
        PANDA_Util.writeModeFile(String.format("Energy: %f %f %f\n", after[0]-before[0], after[1]-before[1], after[2]-before[2]));
        PANDA_Util.writeModeFile(String.format("Time: %s\n", PANDA_Util.elapsedTime()));
        PANDA_Util.closeModeFile();
        EnergyCheckUtils.DeallocProfile();
    }

}

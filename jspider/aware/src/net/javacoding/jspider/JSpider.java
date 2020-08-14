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
 * @author Günther Van Roey
 * @todo support commandline input for proxy password
 * @todo implement Swing-based monitor UI ( threading, progress, ...)
 */
public class JSpider {
    protected Spider spider;
    protected SpiderContext context;

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

        ENT_Util.initModeFile();

        int PANDA_RUNS = Integer.parseInt(System.getenv("PANDA_RUNS"));
        double energyTotal = 0.0;

        for (int k = 0; k < PANDA_RUNS; k++) {
          double[] before = EnergyCheckUtils.getEnergyStats();
          ENT_Util.resetStopwatch();
          ENT_Util.startStopwatch();

          URL baseURL = new URL(args[0]);

          JSpider jspider = new JSpider ( baseURL );
          jspider.start ( );

          double[] after = EnergyCheckUtils.getEnergyStats();
          double diff = after[2]-before[2];

          if (diff < 0) {
            diff += EnergyCheckUtils.wraparoundValue;
          }

          ENT_Util.stopStopwatch();

          ENT_Util.writeModeFile(String.format("ERun %d: %f %f %f %f\n", k, after[0]-before[0], after[1]-before[1], diff, ENT_Util.elapsedTime()));

          System.err.format("Finished %d\n", k);
          System.err.format("Table Size %d\n", ENT_Runtime.objectTableSize());

          try {
            Thread.sleep(30000);
          } catch (Exception e) {
            System.out.println(e);
          }
        }

        ENT_Util.closeModeFile();
        EnergyCheckUtils.DeallocProfile();
    }

}

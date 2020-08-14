package net.javacoding.jspider.core.rule.impl;


import net.javacoding.jspider.api.model.Decision;
import net.javacoding.jspider.api.model.Site;
import net.javacoding.jspider.core.SpiderContext;
import net.javacoding.jspider.core.model.DecisionInternal;
import net.javacoding.jspider.spi.Rule;
import net.javacoding.jspider.core.rule.Ruleset;
import net.javacoding.jspider.mod.rule.PandaDepthRule;

import java.net.URL;
import java.util.List;


/**
 *
 * $Id: RuleSetImpl.java,v 1.9 2003/04/03 16:24:59 vanrogu Exp $
 *
 * @author Günther Van Roey
 */
public class RuleSetImpl@mode<?->X> implements Ruleset@mode<X> {

    private mcase<int> HACK = mcase<int> {low: 0; mid: 0; high: 0; };

    attributor {
      if (ENT_Util.Battery.percentRemaining() >= 0.75) {
        return @mode<high>;
      } else if (ENT_Util.Battery.percentRemaining() >= 0.50) {
        return @mode<mid>;
      } else {
        return @mode<low>;
      }
    }

    protected int type;
    protected Ruleset generalRules;
    protected List localRules;
    protected PandaDepthRule depthRule;

    public RuleSetImpl(int type, List rules) {
        this(type, null, rules);
        this.depthRule = new PandaDepthRule();
        this.localRules.add(this.depthRule);
    }

    public RuleSetImpl(int type, Ruleset generalRules, List rules) {
        this.type = type;
        this.generalRules = generalRules;
        this.localRules = rules;

        this.depthRule = new PandaDepthRule();
        this.localRules.add(this.depthRule);
    }

    public Decision applyRules(SpiderContext context, Site@mode<?> site, Site@mode<*> currentSite, URL url) {
        Decision decision = null;

        String recovstr = System.getenv("PANDA_RECOVER");
        boolean recover = true;
        if (recovstr != null && recovstr.equals("false")) {
          recover = false;
        } 

        Site@mode<*> c_site = null;

        try {
          c_site = snapshot site ?mode[@mode<low>,@mode<X>];
        } catch (RuntimeException e) {
          c_site = snapshotforce site ?mode[@mode<low>,@mode<X>];
          if (recover) {
            this.depthRule.maxDepth = 3;
          }
        }

        if (generalRules != null) {
            decision = generalRules.applyRules(context, site, currentSite, url);
        } else {
            decision = new DecisionInternal();
        }

        if (decision.isVetoable()) {

            Rule[] rules = (Rule[]) localRules.toArray(new Rule[localRules.size()]);
            for (int i = 0; i < rules.length; i++) {
                Rule rule = rules[i];
                Decision lastDecision = rule.apply(context, currentSite, url);
                decision.addStep(rule.getName(), type, lastDecision.getDecision(), lastDecision.getComment() );
                decision.merge(lastDecision);

                if (!lastDecision.isVetoable()) {
                    break;
                }
            }
        }

        decision.addStep("Ruleset",type, decision.getDecision(), "ruleset final decision");

        return decision;
    }

    public void addRule(Rule rule) {
        localRules.add(rule);
    }

    public int getType() {
        return type;
    }

    public String toString ( ) {
        StringBuffer sb = new StringBuffer ( );
        sb.append ( "[" );
        sb.append (translate(type));
        sb.append ( " ruleset]");
        return sb.toString ( );
    }

    public static String translate ( int type ) {
        switch(type){
            case Ruleset.RULESET_GENERAL:
                return "GENERAL";
            case Ruleset.RULESET_SITE:
                return "SITE";
        }
        return "ERROR!";
    }


}

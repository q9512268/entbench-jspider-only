package net.javacoding.jspider.mod.rule;

import net.javacoding.jspider.core.rule.impl.BaseRuleImpl;
import net.javacoding.jspider.core.util.config.PropertySet;
import net.javacoding.jspider.core.util.URLUtil;
import net.javacoding.jspider.core.SpiderContext;
import net.javacoding.jspider.core.model.DecisionInternal;
import net.javacoding.jspider.api.model.Decision;
import net.javacoding.jspider.api.model.Site;

import java.net.URL;

/**
 * $Id: BoundedDepthRule.java,v 1.1 2003/04/07 15:50:58 vanrogu Exp $
 */
public class PandaDepthRule extends BaseRuleImpl {

    public int minDepth = 0;
    public mcase<int> maxDepth = mcase<int> { low: 4; mid: 5; high: 6; };

    public PandaDepthRule() {
    }

    public Decision apply(SpiderContext context, Site currentSite, URL url) {
        int depth = URLUtil.getDepth(url);

        Decision decision = null;

        if ( depth < minDepth ) {
            decision = new DecisionInternal ( Decision.RULE_IGNORE, "depth is " + depth + ", lower than minimum " + minDepth);
        } else if ( depth > maxDepth ) {
            decision = new DecisionInternal ( Decision.RULE_IGNORE, "depth is " + depth + ", higher than maximum " + maxDepth);
        } else {
            decision = new DecisionInternal ( Decision.RULE_ACCEPT, "depth is " + depth + ", within boundaries of [" + minDepth + "," + maxDepth + "]");
        }

        return decision;
    }

}

/*
 * Copyright (c) 2012 Mateusz Parzonka, Eric Bodden
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 * Mateusz Parzonka - initial API and implementation
 */
package prm4j;

import java.util.Collection;
import java.util.Iterator;
import java.util.Map;

import org.aspectj.lang.annotation.SuppressAjWarnings;

import prm4j.api.ParametricMonitor;
import prm4j.api.ParametricMonitorFactory;
import prm4j.api.fsm.FSMSpec;

@SuppressWarnings("rawtypes")
@SuppressAjWarnings({"adviceDidNotMatch"})
public aspect UnsafeMapIterator {
    
    final FSM_UnsafeMapIterator fsm;
    final ParametricMonitor pm;

    public UnsafeMapIterator() {
	fsm = new FSM_UnsafeMapIterator();
	pm = ParametricMonitorFactory.createParametricMonitor(new FSMSpec(fsm.fsm));
	System.out.println("prm4j: Parametric monitor for 'UnsafeMapIterator' created!");
    }

    pointcut UnsafeMapIterator_createColl(Map map) : ((call(* Map.values()) || call(* Map.keySet())) && target(map)) && !within(prm4j..*) && !within(org.dacapo..*);

    after(Map map) returning (Collection c) : UnsafeMapIterator_createColl(map) {
	pm.processEvent(fsm.createColl.createEvent(map, c));
    }

    pointcut UnsafeMapIterator_createIter(Collection c) : (call(* Collection.iterator()) && target(c)) && !within(prm4j..*) && !within(org.dacapo..*);

    after(Collection c) returning (Iterator i) : UnsafeMapIterator_createIter(c) {
	pm.processEvent(fsm.createIter.createEvent(c, i));
    }

    pointcut UnsafeMapIterator_useIter(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(prm4j..*) && !within(org.dacapo..*);

    before(Iterator i) : UnsafeMapIterator_useIter(i) {
	pm.processEvent(fsm.useIter.createEvent(i));
    }

    pointcut UnsafeMapIterator_updateMap(Map map) : ((call(* Map.put*(..)) || call(* Map.putAll*(..)) || call(* Map.clear()) || call(* Map.remove*(..))) && target(map)) && !within(prm4j..*) && !within(org.dacapo..*);

    after(Map map) : UnsafeMapIterator_updateMap(map) {
	pm.processEvent(fsm.updateMap.createEvent(map));
    }
    
    before() : execution (* org.dacapo.harness.Callback+.stop()) {
  	System.out.println("[prm4j.UnsafeMapIterator] Stopping and resetting...");
  	pm.reset();
      }
}

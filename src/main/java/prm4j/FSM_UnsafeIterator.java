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

import prm4j.api.Alphabet;
import prm4j.api.MatchHandler;
import prm4j.api.Parameter;
import prm4j.api.Symbol1;
import prm4j.api.Symbol2;
import prm4j.api.fsm.FSM;
import prm4j.api.fsm.FSMState;

@SuppressWarnings("rawtypes")
public class FSM_UnsafeIterator {

    public final Alphabet alphabet = new Alphabet();

    public final Parameter<Collection> c = alphabet.createParameter("c", Collection.class);
    public final Parameter<Iterator> i = alphabet.createParameter("i", Iterator.class);

    public final Symbol2<Collection, Iterator> createIter = alphabet.createSymbol2("createIter", c, i);
    public final Symbol1<Collection> updateColl = alphabet.createSymbol1("updateColl", c);
    public final Symbol1<Iterator> useIter = alphabet.createSymbol1("useIter", i);

    public final FSM fsm = new FSM(alphabet);

    public final MatchHandler matchHandler = MatchHandler.NO_OP;

    public final FSMState initial = fsm.createInitialState();
    public final FSMState s1 = fsm.createState();
    public final FSMState s2 = fsm.createState();
    public final FSMState s3 = fsm.createState();
    public final FSMState error = fsm.createAcceptingState(matchHandler);

    public FSM_UnsafeIterator() {
	// initial.addTransition(updateColl, initial); // self-loop
	// initial.addTransition(useIter, initial); // self-loop
	initial.addTransition(createIter, s1); // creation event
	s1.addTransition(useIter, s1);
	s1.addTransition(updateColl, s2);
	s2.addTransition(updateColl, s2);
	s2.addTransition(useIter, error);
    }
}

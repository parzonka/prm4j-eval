package mop;
import java.io.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.*;
import javamoprt.*;
import java.lang.ref.*;

class UnsafeMapIteratorMonitor_Set extends javamoprt.MOPSet {
	protected UnsafeMapIteratorMonitor[] elementData;

	public UnsafeMapIteratorMonitor_Set(){
		this.size = 0;
		this.elementData = new UnsafeMapIteratorMonitor[4];
	}

	public final int size(){
		while(size > 0 && elementData[size-1].MOP_terminated) {
			elementData[--size] = null;
		}
		return size;
	}

	public final boolean add(MOPMonitor e){
		ensureCapacity();
		elementData[size++] = (UnsafeMapIteratorMonitor)e;
		return true;
	}

	public final void endObject(int idnum){
		int numAlive = 0;
		for(int i = 0; i < size; i++){
			UnsafeMapIteratorMonitor monitor = elementData[i];
			if(!monitor.MOP_terminated){
				monitor.endObject(idnum);
			}
			if(!monitor.MOP_terminated){
				elementData[numAlive++] = monitor;
			}
		}
		for(int i = numAlive; i < size; i++){
			elementData[i] = null;
		}
		size = numAlive;
	}

	public final boolean alive(){
		for(int i = 0; i < size; i++){
			MOPMonitor monitor = elementData[i];
			if(!monitor.MOP_terminated){
				return true;
			}
		}
		return false;
	}

	public final void endObjectAndClean(int idnum){
		int size = this.size;
		this.size = 0;
		for(int i = size - 1; i >= 0; i--){
			MOPMonitor monitor = elementData[i];
			if(monitor != null && !monitor.MOP_terminated){
				monitor.endObject(idnum);
			}
			elementData[i] = null;
		}
		elementData = null;
	}

	public final void ensureCapacity() {
		int oldCapacity = elementData.length;
		if (size + 1 > oldCapacity) {
			cleanup();
		}
		if (size + 1 > oldCapacity) {
			UnsafeMapIteratorMonitor[] oldData = elementData;
			int newCapacity = (oldCapacity * 3) / 2 + 1;
			if (newCapacity < size + 1){
				newCapacity = size + 1;
			}
			elementData = Arrays.copyOf(oldData, newCapacity);
		}
	}

	public final void cleanup() {
		int numAlive = 0 ;
		for(int i = 0; i < size; i++){
			UnsafeMapIteratorMonitor monitor = (UnsafeMapIteratorMonitor)elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;
			}
		}
		for(int i = numAlive; i < size; i++){
			elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_createColl(Map map, Collection c) {
		int numAlive = 0 ;
		for(int i_1 = 0; i_1 < this.size; i_1++){
			UnsafeMapIteratorMonitor monitor = (UnsafeMapIteratorMonitor)this.elementData[i_1];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_createColl(map, c);
				if(monitor.Prop_1_Category_match) {
					monitor.Prop_1_handler_match(map, c, null);
				}
			}
		}
		for(int i_1 = numAlive; i_1 < this.size; i_1++){
			this.elementData[i_1] = null;
		}
		size = numAlive;
	}

	public final void event_createIter(Collection c, Iterator i) {
		int numAlive = 0 ;
		for(int i_1 = 0; i_1 < this.size; i_1++){
			UnsafeMapIteratorMonitor monitor = (UnsafeMapIteratorMonitor)this.elementData[i_1];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_createIter(c, i);
				if(monitor.Prop_1_Category_match) {
					monitor.Prop_1_handler_match(null, c, i);
				}
			}
		}
		for(int i_1 = numAlive; i_1 < this.size; i_1++){
			this.elementData[i_1] = null;
		}
		size = numAlive;
	}

	public final void event_useIter(Iterator i) {
		int numAlive = 0 ;
		for(int i_1 = 0; i_1 < this.size; i_1++){
			UnsafeMapIteratorMonitor monitor = (UnsafeMapIteratorMonitor)this.elementData[i_1];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_useIter(i);
				if(monitor.Prop_1_Category_match) {
					monitor.Prop_1_handler_match(null, null, i);
				}
			}
		}
		for(int i_1 = numAlive; i_1 < this.size; i_1++){
			this.elementData[i_1] = null;
		}
		size = numAlive;
	}

	public final void event_updateMap(Map map) {
		int numAlive = 0 ;
		for(int i_1 = 0; i_1 < this.size; i_1++){
			UnsafeMapIteratorMonitor monitor = (UnsafeMapIteratorMonitor)this.elementData[i_1];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_updateMap(map);
				if(monitor.Prop_1_Category_match) {
					monitor.Prop_1_handler_match(map, null, null);
				}
			}
		}
		for(int i_1 = numAlive; i_1 < this.size; i_1++){
			this.elementData[i_1] = null;
		}
		size = numAlive;
	}
}

class UnsafeMapIteratorMonitor extends javamoprt.MOPMonitor implements Cloneable, javamoprt.MOPObject {
    
	/**
	 *  prm4j-eval: resets the parametric monitor
	 */
	static AtomicInteger MATCHES = new AtomicInteger(); // prm4j-eval
	
	public long tau = -1;
	public Object clone() {
		try {
			UnsafeMapIteratorMonitor ret = (UnsafeMapIteratorMonitor) super.clone();
			ret.monitorInfo = (javamoprt.MOPMonitorInfo)this.monitorInfo.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}

	int Prop_1_state;
	static final int Prop_1_transition_createColl[] = {2, 5, 5, 5, 5, 5};;
	static final int Prop_1_transition_createIter[] = {5, 5, 1, 5, 5, 5};;
	static final int Prop_1_transition_useIter[] = {5, 1, 5, 5, 3, 5};;
	static final int Prop_1_transition_updateMap[] = {5, 4, 2, 5, 4, 5};;

	boolean Prop_1_Category_match = false;

	public UnsafeMapIteratorMonitor () {
		Prop_1_state = 0;

	}

	public final void Prop_1_event_createColl(Map map, Collection c) {
		MOP_lastevent = 0;

		Prop_1_state = Prop_1_transition_createColl[Prop_1_state];
		if(this.monitorInfo.isFullParam){
			Prop_1_Category_match = Prop_1_state == 3;
		}
	}

	public final void Prop_1_event_createIter(Collection c, Iterator i) {
		MOP_lastevent = 1;

		Prop_1_state = Prop_1_transition_createIter[Prop_1_state];
		if(this.monitorInfo.isFullParam){
			Prop_1_Category_match = Prop_1_state == 3;
		}
	}

	public final void Prop_1_event_useIter(Iterator i) {
		MOP_lastevent = 2;

		Prop_1_state = Prop_1_transition_useIter[Prop_1_state];
		if(this.monitorInfo.isFullParam){
			Prop_1_Category_match = Prop_1_state == 3;
		}
	}

	public final void Prop_1_event_updateMap(Map map) {
		MOP_lastevent = 3;

		Prop_1_state = Prop_1_transition_updateMap[Prop_1_state];
		if(this.monitorInfo.isFullParam){
			Prop_1_Category_match = Prop_1_state == 3;
		}
	}

	public final void Prop_1_handler_match (Map map, Collection c, Iterator i){
	    {
		MATCHES.incrementAndGet(); // prm4j-eval
	    }

	}

	public final void reset() {
		MOP_lastevent = -1;
		Prop_1_state = 0;
		Prop_1_Category_match = false;
	}

	public javamoprt.ref.MOPTagWeakReference MOPRef_map;
	public javamoprt.ref.MOPTagWeakReference MOPRef_c;
	public javamoprt.ref.MOPTagWeakReference MOPRef_i;

	//alive_parameters_0 = [Map map, Collection c, Iterator i]
	public boolean alive_parameters_0 = true;
	//alive_parameters_1 = [Map map, Iterator i]
	public boolean alive_parameters_1 = true;
	//alive_parameters_2 = [Iterator i]
	public boolean alive_parameters_2 = true;

	public final void endObject(int idnum){
		switch(idnum){
			case 0:
			alive_parameters_0 = false;
			alive_parameters_1 = false;
			break;
			case 1:
			alive_parameters_0 = false;
			break;
			case 2:
			alive_parameters_0 = false;
			alive_parameters_1 = false;
			alive_parameters_2 = false;
			break;
		}
		switch(MOP_lastevent) {
			case -1:
			return;
			case 0:
			//createColl
			//alive_map && alive_c && alive_i
			if(!(alive_parameters_0)){
				MOP_terminated = true;
				return;
			}
			break;

			case 1:
			//createIter
			//alive_map && alive_i
			if(!(alive_parameters_1)){
				MOP_terminated = true;
				return;
			}
			break;

			case 2:
			//useIter
			//alive_map && alive_i
			if(!(alive_parameters_1)){
				MOP_terminated = true;
				return;
			}
			break;

			case 3:
			//updateMap
			//alive_i
			if(!(alive_parameters_2)){
				MOP_terminated = true;
				return;
			}
			break;

		}
		return;
	}

	javamoprt.MOPMonitorInfo monitorInfo;
}

public aspect UnsafeMapIteratorMonitorAspect implements javamoprt.MOPObject {
	javamoprt.map.MOPMapManager UnsafeMapIteratorMapManager;
	private final MemoryLogger memoryLogger; // prm4j-eval
	public UnsafeMapIteratorMonitorAspect(){
		UnsafeMapIteratorMapManager = new javamoprt.map.MOPMapManager();
		UnsafeMapIteratorMapManager.start();
		System.out.println("[JavaMOP.UnsafeMapIterator] Started"); // prm4j-eval
		memoryLogger = new MemoryLogger(); // prm4j-eval
	}

	// Declarations for the Lock
	static ReentrantLock UnsafeMapIterator_MOPLock = new ReentrantLock();
	static Condition UnsafeMapIterator_MOPLock_cond = UnsafeMapIterator_MOPLock.newCondition();

	// Declarations for Timestamps
	static long UnsafeMapIterator_timestamp = 1;

	static boolean UnsafeMapIterator_activated = false;

	// Declarations for Indexing Trees
	static javamoprt.map.MOPAbstractMap UnsafeMapIterator_map_c_i_Map = new javamoprt.map.MOPMapOfAll(0);
	static javamoprt.ref.MOPTagWeakReference UnsafeMapIterator_map_c_i_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
	static javamoprt.ref.MOPTagWeakReference UnsafeMapIterator_map_c_i_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
	static javamoprt.ref.MOPTagWeakReference UnsafeMapIterator_map_c_i_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
	static UnsafeMapIteratorMonitor UnsafeMapIterator_map_c_i_Map_cachenode = null;
	static javamoprt.ref.MOPTagWeakReference UnsafeMapIterator_map_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
	static UnsafeMapIteratorMonitor_Set UnsafeMapIterator_map_Map_cacheset = null;
	static UnsafeMapIteratorMonitor UnsafeMapIterator_map_Map_cachenode = null;
	static javamoprt.map.MOPAbstractMap UnsafeMapIterator_c_i_Map = new javamoprt.map.MOPMapOfAll(1);
	static javamoprt.ref.MOPTagWeakReference UnsafeMapIterator_c_i_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
	static javamoprt.ref.MOPTagWeakReference UnsafeMapIterator_c_i_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
	static UnsafeMapIteratorMonitor_Set UnsafeMapIterator_c_i_Map_cacheset = null;
	static UnsafeMapIteratorMonitor UnsafeMapIterator_c_i_Map_cachenode = null;
	static javamoprt.ref.MOPTagWeakReference UnsafeMapIterator_map_c_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
	static javamoprt.ref.MOPTagWeakReference UnsafeMapIterator_map_c_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
	static UnsafeMapIteratorMonitor_Set UnsafeMapIterator_map_c_Map_cacheset = null;
	static UnsafeMapIteratorMonitor UnsafeMapIterator_map_c_Map_cachenode = null;
	static javamoprt.map.MOPAbstractMap UnsafeMapIterator_i_Map = new javamoprt.map.MOPMapOfSetMon(2);
	static javamoprt.ref.MOPTagWeakReference UnsafeMapIterator_i_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
	static UnsafeMapIteratorMonitor_Set UnsafeMapIterator_i_Map_cacheset = null;
	static UnsafeMapIteratorMonitor UnsafeMapIterator_i_Map_cachenode = null;
	static javamoprt.map.MOPAbstractMap UnsafeMapIterator_c__To__map_c_Map = new javamoprt.map.MOPMapOfSetMon(1);

	// Trees for References
	static javamoprt.map.MOPRefMap UnsafeMapIterator_Collection_RefMap = new javamoprt.map.MOPTagRefMap();
	static javamoprt.map.MOPRefMap UnsafeMapIterator_Iterator_RefMap = new javamoprt.map.MOPTagRefMap();
	static javamoprt.map.MOPRefMap UnsafeMapIterator_Map_RefMap = new javamoprt.map.MOPTagRefMap();

	pointcut MOP_CommonPointCut() : !within(javamoprt.MOPObject+) && !adviceexecution();
	pointcut UnsafeMapIterator_createColl(Map map) : ((call(* Map.values()) || call(* Map.keySet())) && target(map)) && MOP_CommonPointCut();
	after (Map map) returning (Collection c) : UnsafeMapIterator_createColl(map) {
		UnsafeMapIterator_activated = true;
		while (!UnsafeMapIterator_MOPLock.tryLock()) {
			Thread.yield();
		}
		memoryLogger.logMemoryConsumption(); // prm4j-eval
		Object obj;
		javamoprt.map.MOPMap tempMap;
		UnsafeMapIteratorMonitor mainMonitor = null;
		javamoprt.map.MOPMap mainMap = null;
		UnsafeMapIteratorMonitor_Set mainSet = null;
		UnsafeMapIteratorMonitor_Set monitors = null;
		javamoprt.ref.MOPTagWeakReference TempRef_map;
		javamoprt.ref.MOPTagWeakReference TempRef_c;

		// Cache Retrieval
		if (map == UnsafeMapIterator_map_c_Map_cachekey_0.get() && c == UnsafeMapIterator_map_c_Map_cachekey_1.get()) {
			TempRef_map = UnsafeMapIterator_map_c_Map_cachekey_0;
			TempRef_c = UnsafeMapIterator_map_c_Map_cachekey_1;

			mainSet = UnsafeMapIterator_map_c_Map_cacheset;
			mainMonitor = UnsafeMapIterator_map_c_Map_cachenode;
		} else {
			TempRef_map = UnsafeMapIterator_Map_RefMap.getTagRef(map);
			TempRef_c = UnsafeMapIterator_Collection_RefMap.getTagRef(c);
		}

		if (mainSet == null || mainMonitor == null) {
			tempMap = UnsafeMapIterator_map_c_i_Map;
			obj = tempMap.getMap(TempRef_map);
			if (obj == null) {
				obj = new javamoprt.map.MOPMapOfSetMon(1);
				tempMap.putMap(TempRef_map, obj);
			}
			mainMap = (javamoprt.map.MOPAbstractMap)obj;
			mainMonitor = (UnsafeMapIteratorMonitor)mainMap.getNode(TempRef_c);
			mainSet = (UnsafeMapIteratorMonitor_Set)mainMap.getSet(TempRef_c);
			if (mainSet == null){
				mainSet = new UnsafeMapIteratorMonitor_Set();
				mainMap.putSet(TempRef_c, mainSet);
			}

			if (mainMonitor == null) {
				mainMonitor = new UnsafeMapIteratorMonitor();
				mainMonitor.monitorInfo = new javamoprt.MOPMonitorInfo();
				mainMonitor.monitorInfo.isFullParam = false;

				mainMonitor.MOPRef_map = TempRef_map;
				mainMonitor.MOPRef_c = TempRef_c;

				mainMap.putNode(TempRef_c, mainMonitor);
				mainSet.add(mainMonitor);
				mainMonitor.tau = UnsafeMapIterator_timestamp;
				if (TempRef_map.tau == -1){
					TempRef_map.tau = UnsafeMapIterator_timestamp;
				}
				if (TempRef_c.tau == -1){
					TempRef_c.tau = UnsafeMapIterator_timestamp;
				}
				UnsafeMapIterator_timestamp++;

				tempMap = UnsafeMapIterator_map_c_i_Map;
				obj = tempMap.getSet(TempRef_map);
				monitors = (UnsafeMapIteratorMonitor_Set)obj;
				if (monitors == null) {
					monitors = new UnsafeMapIteratorMonitor_Set();
					tempMap.putSet(TempRef_map, monitors);
				}
				monitors.add(mainMonitor);

				tempMap = UnsafeMapIterator_c__To__map_c_Map;
				obj = tempMap.getSet(TempRef_c);
				monitors = (UnsafeMapIteratorMonitor_Set)obj;
				if (monitors == null) {
					monitors = new UnsafeMapIteratorMonitor_Set();
					tempMap.putSet(TempRef_c, monitors);
				}
				monitors.add(mainMonitor);
			}

			UnsafeMapIterator_map_c_Map_cachekey_0 = TempRef_map;
			UnsafeMapIterator_map_c_Map_cachekey_1 = TempRef_c;
			UnsafeMapIterator_map_c_Map_cacheset = mainSet;
			UnsafeMapIterator_map_c_Map_cachenode = mainMonitor;
		}

		if(mainSet != null) {
			mainSet.event_createColl(map, c);
		}
		UnsafeMapIterator_MOPLock.unlock();
	}

	pointcut UnsafeMapIterator_createIter(Collection c) : (call(* Collection.iterator()) && target(c)) && MOP_CommonPointCut();
	after (Collection c) returning (Iterator i) : UnsafeMapIterator_createIter(c) {
		while (!UnsafeMapIterator_MOPLock.tryLock()) {
			Thread.yield();
		}
		memoryLogger.logMemoryConsumption(); // prm4j-eval
		if (UnsafeMapIterator_activated) {
			Object obj;
			javamoprt.map.MOPMap tempMap;
			UnsafeMapIteratorMonitor mainMonitor = null;
			UnsafeMapIteratorMonitor origMonitor = null;
			UnsafeMapIteratorMonitor lastMonitor = null;
			javamoprt.map.MOPMap mainMap = null;
			javamoprt.map.MOPMap origMap = null;
			javamoprt.map.MOPMap lastMap = null;
			UnsafeMapIteratorMonitor_Set mainSet = null;
			UnsafeMapIteratorMonitor_Set origSet = null;
			UnsafeMapIteratorMonitor_Set monitors = null;
			javamoprt.ref.MOPTagWeakReference TempRef_map;
			javamoprt.ref.MOPTagWeakReference TempRef_c;
			javamoprt.ref.MOPTagWeakReference TempRef_i;

			// Cache Retrieval
			if (c == UnsafeMapIterator_c_i_Map_cachekey_1.get() && i == UnsafeMapIterator_c_i_Map_cachekey_2.get()) {
				TempRef_c = UnsafeMapIterator_c_i_Map_cachekey_1;
				TempRef_i = UnsafeMapIterator_c_i_Map_cachekey_2;

				mainSet = UnsafeMapIterator_c_i_Map_cacheset;
				mainMonitor = UnsafeMapIterator_c_i_Map_cachenode;
			} else {
				TempRef_c = UnsafeMapIterator_Collection_RefMap.getTagRef(c);
				TempRef_i = UnsafeMapIterator_Iterator_RefMap.getTagRef(i);
			}

			if (mainSet == null || mainMonitor == null) {
				tempMap = UnsafeMapIterator_c_i_Map;
				obj = tempMap.getMap(TempRef_c);
				if (obj != null) {
					mainMap = (javamoprt.map.MOPAbstractMap)obj;
					mainMonitor = (UnsafeMapIteratorMonitor)mainMap.getNode(TempRef_i);
					mainSet = (UnsafeMapIteratorMonitor_Set)mainMap.getSet(TempRef_i);
				}

				if (mainMonitor == null) {
					origMap = UnsafeMapIterator_c__To__map_c_Map;
					origSet = (UnsafeMapIteratorMonitor_Set)origMap.getSet(TempRef_c);
					if (origSet!= null) {
						int numAlive = 0;
						for(int i_1 = 0; i_1 < origSet.size; i_1++) {
							origMonitor = origSet.elementData[i_1];
							Map map = (Map)origMonitor.MOPRef_map.get();
							if (!origMonitor.MOP_terminated && map != null) {
								origSet.elementData[numAlive] = origMonitor;
								numAlive++;

								TempRef_map = origMonitor.MOPRef_map;

								tempMap = UnsafeMapIterator_map_c_i_Map;
								obj = tempMap.getMap(TempRef_map);
								if (obj == null) {
									obj = new javamoprt.map.MOPMapOfAll(1);
									tempMap.putMap(TempRef_map, obj);
								}
								tempMap = (javamoprt.map.MOPAbstractMap)obj;
								obj = tempMap.getMap(TempRef_c);
								if (obj == null) {
									obj = new javamoprt.map.MOPMapOfMonitor(2);
									tempMap.putMap(TempRef_c, obj);
								}
								lastMap = (javamoprt.map.MOPAbstractMap)obj;
								lastMonitor = (UnsafeMapIteratorMonitor)lastMap.getNode(TempRef_i);
								if (lastMonitor == null) {
									boolean timeCheck = true;

									if (TempRef_i.disable > origMonitor.tau|| (TempRef_i.tau > 0 && TempRef_i.tau < origMonitor.tau)) {
										timeCheck = false;
									}

									if (timeCheck) {
										lastMonitor = (UnsafeMapIteratorMonitor)origMonitor.clone();
										lastMonitor.MOPRef_i = TempRef_i;
										if (TempRef_i.tau == -1){
											TempRef_i.tau = origMonitor.tau;
										}
										lastMap.putNode(TempRef_i, lastMonitor);
										lastMonitor.monitorInfo.isFullParam = true;

										tempMap = UnsafeMapIterator_map_c_i_Map;
										obj = tempMap.getSet(TempRef_map);
										monitors = (UnsafeMapIteratorMonitor_Set)obj;
										if (monitors == null) {
											monitors = new UnsafeMapIteratorMonitor_Set();
											tempMap.putSet(TempRef_map, monitors);
										}
										monitors.add(lastMonitor);

										mainMap = UnsafeMapIterator_c_i_Map;
										obj = mainMap.getMap(TempRef_c);
										if (obj == null) {
											obj = new javamoprt.map.MOPMapOfSetMon(1);
											mainMap.putMap(TempRef_c, obj);
										}
										mainMap = (javamoprt.map.MOPAbstractMap)obj;
										obj = mainMap.getSet(TempRef_i);
										mainSet = (UnsafeMapIteratorMonitor_Set)obj;
										if (mainSet == null) {
											mainSet = new UnsafeMapIteratorMonitor_Set();
											mainMap.putSet(TempRef_i, mainSet);
										}
										mainSet.add(lastMonitor);

										tempMap = UnsafeMapIterator_map_c_i_Map;
										obj = tempMap.getMap(TempRef_map);
										if (obj == null) {
											obj = new javamoprt.map.MOPMapOfSetMon(0);
											tempMap.putMap(TempRef_map, obj);
										}
										tempMap = (javamoprt.map.MOPAbstractMap)obj;
										obj = tempMap.getSet(TempRef_c);
										monitors = (UnsafeMapIteratorMonitor_Set)obj;
										if (monitors == null) {
											monitors = new UnsafeMapIteratorMonitor_Set();
											tempMap.putSet(TempRef_c, monitors);
										}
										monitors.add(lastMonitor);

										tempMap = UnsafeMapIterator_i_Map;
										obj = tempMap.getSet(TempRef_i);
										monitors = (UnsafeMapIteratorMonitor_Set)obj;
										if (monitors == null) {
											monitors = new UnsafeMapIteratorMonitor_Set();
											tempMap.putSet(TempRef_i, monitors);
										}
										monitors.add(lastMonitor);
									}
								}
							}
						}

						for(int i_1 = numAlive; i_1 < origSet.size; i_1++) {
							origSet.elementData[i_1] = null;
						}
						origSet.size = numAlive;
					}

					TempRef_i.disable = UnsafeMapIterator_timestamp;
					UnsafeMapIterator_timestamp++;
				}

				UnsafeMapIterator_c_i_Map_cachekey_1 = TempRef_c;
				UnsafeMapIterator_c_i_Map_cachekey_2 = TempRef_i;
				UnsafeMapIterator_c_i_Map_cacheset = mainSet;
				UnsafeMapIterator_c_i_Map_cachenode = mainMonitor;
			}

			if(mainSet != null) {
				mainSet.event_createIter(c, i);
			}
		}
		UnsafeMapIterator_MOPLock.unlock();
	}

	pointcut UnsafeMapIterator_useIter(Iterator i) : (call(* Iterator.next()) && target(i)) && MOP_CommonPointCut();
	before (Iterator i) : UnsafeMapIterator_useIter(i) {
		while (!UnsafeMapIterator_MOPLock.tryLock()) {
			Thread.yield();
		}
		memoryLogger.logMemoryConsumption(); // prm4j-eval
		if (UnsafeMapIterator_activated) {
			UnsafeMapIteratorMonitor mainMonitor = null;
			javamoprt.map.MOPMap mainMap = null;
			UnsafeMapIteratorMonitor_Set mainSet = null;
			javamoprt.ref.MOPTagWeakReference TempRef_i;

			// Cache Retrieval
			if (i == UnsafeMapIterator_i_Map_cachekey_2.get()) {
				TempRef_i = UnsafeMapIterator_i_Map_cachekey_2;

				mainSet = UnsafeMapIterator_i_Map_cacheset;
				mainMonitor = UnsafeMapIterator_i_Map_cachenode;
			} else {
				TempRef_i = UnsafeMapIterator_Iterator_RefMap.getTagRef(i);
			}

			if (mainSet == null || mainMonitor == null) {
				mainMap = UnsafeMapIterator_i_Map;
				mainMonitor = (UnsafeMapIteratorMonitor)mainMap.getNode(TempRef_i);
				mainSet = (UnsafeMapIteratorMonitor_Set)mainMap.getSet(TempRef_i);

				if (mainMonitor == null) {

					TempRef_i.disable = UnsafeMapIterator_timestamp;
					UnsafeMapIterator_timestamp++;
				}

				UnsafeMapIterator_i_Map_cachekey_2 = TempRef_i;
				UnsafeMapIterator_i_Map_cacheset = mainSet;
				UnsafeMapIterator_i_Map_cachenode = mainMonitor;
			}

			if(mainSet != null) {
				mainSet.event_useIter(i);
			}
		}
		UnsafeMapIterator_MOPLock.unlock();
	}

	pointcut UnsafeMapIterator_updateMap(Map map) : ((call(* Map.put*(..)) || call(* Map.putAll*(..)) || call(* Map.clear()) || call(* Map.remove*(..))) && target(map)) && MOP_CommonPointCut();
	after (Map map) : UnsafeMapIterator_updateMap(map) {
		while (!UnsafeMapIterator_MOPLock.tryLock()) {
			Thread.yield();
		}
		memoryLogger.logMemoryConsumption(); // prm4j-eval
		if (UnsafeMapIterator_activated) {
			UnsafeMapIteratorMonitor mainMonitor = null;
			javamoprt.map.MOPMap mainMap = null;
			UnsafeMapIteratorMonitor_Set mainSet = null;
			javamoprt.ref.MOPTagWeakReference TempRef_map;

			// Cache Retrieval
			if (map == UnsafeMapIterator_map_Map_cachekey_0.get()) {
				TempRef_map = UnsafeMapIterator_map_Map_cachekey_0;

				mainSet = UnsafeMapIterator_map_Map_cacheset;
			} else {
				TempRef_map = UnsafeMapIterator_Map_RefMap.getTagRefNonCreative(map);
			}

			if ((mainSet == null) && TempRef_map != javamoprt.map.MOPTagRefMap.NULRef) {
				mainMap = UnsafeMapIterator_map_c_i_Map;
				mainSet = (UnsafeMapIteratorMonitor_Set)mainMap.getSet(TempRef_map);

				UnsafeMapIterator_map_Map_cachekey_0 = TempRef_map;
				UnsafeMapIterator_map_Map_cacheset = mainSet;
				UnsafeMapIterator_map_Map_cachenode = mainMonitor;
			}

			if(mainSet != null) {
				mainSet.event_updateMap(map);
			}
		}
		UnsafeMapIterator_MOPLock.unlock();
	}
	
	/**
	 *  prm4j-eval: resets the parametric monitor
	 */
	after() : execution (* org.dacapo.harness.Callback+.stop()) {
		System.out.println("[JavaMOP.UnsafeMapIterator] Resetting... Reported " + UnsafeMapIteratorMonitor.MATCHES.get() + " matches.");

		memoryLogger.reallyLogMemoryConsumption(); // so we have at least two values
		
		UnsafeMapIterator_timestamp = 1;

		UnsafeMapIterator_activated = false;
		
		// Indexing Trees
		UnsafeMapIterator_map_c_i_Map = new javamoprt.map.MOPMapOfAll(0);
		UnsafeMapIterator_map_c_i_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
		UnsafeMapIterator_map_c_i_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
		UnsafeMapIterator_map_c_i_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
		UnsafeMapIterator_map_c_i_Map_cachenode = null;
		UnsafeMapIterator_map_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
		UnsafeMapIterator_map_Map_cacheset = null;
		UnsafeMapIterator_map_Map_cachenode = null;
		UnsafeMapIterator_c_i_Map = new javamoprt.map.MOPMapOfAll(1);
		UnsafeMapIterator_c_i_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
		UnsafeMapIterator_c_i_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
		UnsafeMapIterator_c_i_Map_cacheset = null;
		UnsafeMapIterator_c_i_Map_cachenode = null;
		UnsafeMapIterator_map_c_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
		UnsafeMapIterator_map_c_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
		UnsafeMapIterator_map_c_Map_cacheset = null;
		UnsafeMapIterator_map_c_Map_cachenode = null;
		UnsafeMapIterator_i_Map = new javamoprt.map.MOPMapOfSetMon(2);
		UnsafeMapIterator_i_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
		UnsafeMapIterator_i_Map_cacheset = null;
		UnsafeMapIterator_i_Map_cachenode = null;
		UnsafeMapIterator_c__To__map_c_Map = new javamoprt.map.MOPMapOfSetMon(1);

		// Trees for References
		UnsafeMapIterator_Collection_RefMap = new javamoprt.map.MOPTagRefMap();
		UnsafeMapIterator_Iterator_RefMap = new javamoprt.map.MOPTagRefMap();
		UnsafeMapIterator_Map_RefMap = new javamoprt.map.MOPTagRefMap();

		
		UnsafeMapIteratorMapManager = new javamoprt.map.MOPMapManager();
		UnsafeMapIteratorMapManager.start();
		
		memoryLogger.writeToFile(UnsafeMapIteratorMonitor.MATCHES.get());
		
		UnsafeMapIteratorMonitor.MATCHES.set(0); // reset counter
		
		System.gc();
		System.gc();
	}

}

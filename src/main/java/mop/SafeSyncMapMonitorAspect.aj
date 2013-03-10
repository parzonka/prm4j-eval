package mop;
import java.io.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.*;
import javamoprt.*;
import java.lang.ref.*;

class SafeSyncMapMonitor_Set extends javamoprt.MOPSet {
	protected SafeSyncMapMonitor[] elementData;

	public SafeSyncMapMonitor_Set(){
		this.size = 0;
		this.elementData = new SafeSyncMapMonitor[4];
	}

	public final int size(){
		while(size > 0 && elementData[size-1].MOP_terminated) {
			elementData[--size] = null;
		}
		return size;
	}

	public final boolean add(MOPMonitor e){
		ensureCapacity();
		elementData[size++] = (SafeSyncMapMonitor)e;
		return true;
	}

	public final void endObject(int idnum){
		int numAlive = 0;
		for(int i = 0; i < size; i++){
			SafeSyncMapMonitor monitor = elementData[i];
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
			SafeSyncMapMonitor[] oldData = elementData;
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
			SafeSyncMapMonitor monitor = (SafeSyncMapMonitor)elementData[i];
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

	public final void event_sync(Map syncMap) {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SafeSyncMapMonitor monitor = (SafeSyncMapMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_sync(syncMap);
				if(monitor.Prop_1_Category_match) {
					monitor.Prop_1_handler_match(syncMap, null, null);
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_createSet(Map syncMap, Set mapSet) {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SafeSyncMapMonitor monitor = (SafeSyncMapMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_createSet(syncMap, mapSet);
				if(monitor.Prop_1_Category_match) {
					monitor.Prop_1_handler_match(syncMap, mapSet, null);
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_syncCreateIter(Set mapSet, Iterator iter) {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SafeSyncMapMonitor monitor = (SafeSyncMapMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_syncCreateIter(mapSet, iter);
				if(monitor.MOP_conditionFail){
					monitor.MOP_conditionFail = false;
				} else {
					if(monitor.Prop_1_Category_match) {
						monitor.Prop_1_handler_match(null, mapSet, iter);
					}
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_asyncCreateIter(Set mapSet, Iterator iter) {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SafeSyncMapMonitor monitor = (SafeSyncMapMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_asyncCreateIter(mapSet, iter);
				if(monitor.MOP_conditionFail){
					monitor.MOP_conditionFail = false;
				} else {
					if(monitor.Prop_1_Category_match) {
						monitor.Prop_1_handler_match(null, mapSet, iter);
					}
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_accessIter(Iterator iter) {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SafeSyncMapMonitor monitor = (SafeSyncMapMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_accessIter(iter);
				if(monitor.MOP_conditionFail){
					monitor.MOP_conditionFail = false;
				} else {
					if(monitor.Prop_1_Category_match) {
						monitor.Prop_1_handler_match(null, null, iter);
					}
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}
}

class SafeSyncMapMonitor extends javamoprt.MOPMonitor implements Cloneable, javamoprt.MOPObject {
    
	/**
	 *  prm4j-eval: Measures number of matches.
	 */
	static AtomicInteger MATCHES = new AtomicInteger(); // prm4j-eval
	
	public long tau = -1;
	public Object clone() {
		try {
			SafeSyncMapMonitor ret = (SafeSyncMapMonitor) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	Map c;

	boolean MOP_conditionFail = false;
	int Prop_1_state;
	static final int Prop_1_transition_sync[] = {2, 5, 5, 5, 5, 5};;
	static final int Prop_1_transition_createSet[] = {5, 5, 1, 5, 5, 5};;
	static final int Prop_1_transition_syncCreateIter[] = {5, 4, 5, 5, 5, 5};;
	static final int Prop_1_transition_asyncCreateIter[] = {5, 3, 5, 5, 5, 5};;
	static final int Prop_1_transition_accessIter[] = {5, 5, 5, 5, 3, 5};;

	boolean Prop_1_Category_match = false;

	public SafeSyncMapMonitor () {
		Prop_1_state = 0;

	}

	public final void Prop_1_event_sync(Map syncMap) {
		MOP_lastevent = 0;

		Prop_1_state = Prop_1_transition_sync[Prop_1_state];
		Prop_1_Category_match = Prop_1_state == 3;
		{
			this.c = syncMap;
		}
	}

	public final void Prop_1_event_createSet(Map syncMap, Set mapSet) {
		MOP_lastevent = 1;

		Prop_1_state = Prop_1_transition_createSet[Prop_1_state];
		Prop_1_Category_match = Prop_1_state == 3;
	}

	public final void Prop_1_event_syncCreateIter(Set mapSet, Iterator iter) {
		if (!(Thread.holdsLock(c)
		)) {
			MOP_conditionFail = true;
			return;
		}
		MOP_lastevent = 2;

		Prop_1_state = Prop_1_transition_syncCreateIter[Prop_1_state];
		Prop_1_Category_match = Prop_1_state == 3;
	}

	public final void Prop_1_event_asyncCreateIter(Set mapSet, Iterator iter) {
		if (!(!Thread.holdsLock(c)
		)) {
			MOP_conditionFail = true;
			return;
		}
		MOP_lastevent = 3;

		Prop_1_state = Prop_1_transition_asyncCreateIter[Prop_1_state];
		Prop_1_Category_match = Prop_1_state == 3;
	}

	public final void Prop_1_event_accessIter(Iterator iter) {
		if (!(!Thread.holdsLock(c)
		)) {
			MOP_conditionFail = true;
			return;
		}
		MOP_lastevent = 4;

		Prop_1_state = Prop_1_transition_accessIter[Prop_1_state];
		Prop_1_Category_match = Prop_1_state == 3;
	}

	public final void Prop_1_handler_match (Map syncMap, Set mapSet, Iterator iter){
		{
			System.out.println("synchronized collection accessed in non threadsafe manner!");
		}

	}

	public final void reset() {
		MOP_lastevent = -1;
		Prop_1_state = 0;
		Prop_1_Category_match = false;
	}

	public javamoprt.ref.MOPTagWeakReference MOPRef_syncMap;
	public javamoprt.ref.MOPTagWeakReference MOPRef_mapSet;
	public javamoprt.ref.MOPTagWeakReference MOPRef_iter;

	//alive_parameters_0 = [Map syncMap, Set mapSet, Iterator iter]
	public boolean alive_parameters_0 = true;
	//alive_parameters_1 = [Set mapSet, Iterator iter]
	public boolean alive_parameters_1 = true;
	//alive_parameters_2 = [Iterator iter]
	public boolean alive_parameters_2 = true;

	public final void endObject(int idnum){
		switch(idnum){
			case 0:
			alive_parameters_0 = false;
			break;
			case 1:
			alive_parameters_0 = false;
			alive_parameters_1 = false;
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
			//sync
			//alive_syncMap && alive_mapSet && alive_iter
			if(!(alive_parameters_0)){
				MOP_terminated = true;
				return;
			}
			break;

			case 1:
			//createSet
			//alive_mapSet && alive_iter
			if(!(alive_parameters_1)){
				MOP_terminated = true;
				return;
			}
			break;

			case 2:
			//syncCreateIter
			//alive_iter
			if(!(alive_parameters_2)){
				MOP_terminated = true;
				return;
			}
			break;

			case 3:
			//asyncCreateIter
			return;
			case 4:
			//accessIter
			return;
		}
		return;
	}

}

public aspect SafeSyncMapMonitorAspect implements javamoprt.MOPObject {
	javamoprt.map.MOPMapManager SafeSyncMapMapManager;
	private final MemoryLogger memoryLogger; // prm4j-eval
	public SafeSyncMapMonitorAspect(){
		SafeSyncMapMapManager = new javamoprt.map.MOPMapManager();
		SafeSyncMapMapManager.start();
		memoryLogger = new MemoryLogger(); // prm4j-eval
		System.out.println("[JavaMOP.SafeSyncMap] Started"); // prm4j-eval
	}

	// Declarations for the Lock
	static ReentrantLock SafeSyncMap_MOPLock = new ReentrantLock();
	static Condition SafeSyncMap_MOPLock_cond = SafeSyncMap_MOPLock.newCondition();

	// Declarations for Timestamps
	static long SafeSyncMap_timestamp = 1;

	static boolean SafeSyncMap_activated = false;

	// Declarations for Indexing Trees
	static javamoprt.map.MOPAbstractMap SafeSyncMap_mapSet_iter_Map = new javamoprt.map.MOPMapOfAll(1);
	static javamoprt.ref.MOPTagWeakReference SafeSyncMap_mapSet_iter_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
	static javamoprt.ref.MOPTagWeakReference SafeSyncMap_mapSet_iter_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
	static SafeSyncMapMonitor_Set SafeSyncMap_mapSet_iter_Map_cacheset = null;
	static SafeSyncMapMonitor SafeSyncMap_mapSet_iter_Map_cachenode = null;
	static javamoprt.ref.MOPTagWeakReference SafeSyncMap_syncMap_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
	static SafeSyncMapMonitor_Set SafeSyncMap_syncMap_Map_cacheset = null;
	static SafeSyncMapMonitor SafeSyncMap_syncMap_Map_cachenode = null;
	static javamoprt.map.MOPAbstractMap SafeSyncMap_syncMap_mapSet_iter_Map = new javamoprt.map.MOPMapOfAll(0);
	static javamoprt.ref.MOPTagWeakReference SafeSyncMap_syncMap_mapSet_iter_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
	static javamoprt.ref.MOPTagWeakReference SafeSyncMap_syncMap_mapSet_iter_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
	static javamoprt.ref.MOPTagWeakReference SafeSyncMap_syncMap_mapSet_iter_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
	static SafeSyncMapMonitor SafeSyncMap_syncMap_mapSet_iter_Map_cachenode = null;
	static javamoprt.ref.MOPTagWeakReference SafeSyncMap_syncMap_mapSet_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
	static javamoprt.ref.MOPTagWeakReference SafeSyncMap_syncMap_mapSet_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
	static SafeSyncMapMonitor_Set SafeSyncMap_syncMap_mapSet_Map_cacheset = null;
	static SafeSyncMapMonitor SafeSyncMap_syncMap_mapSet_Map_cachenode = null;
	static javamoprt.map.MOPAbstractMap SafeSyncMap_iter_Map = new javamoprt.map.MOPMapOfSetMon(2);
	static javamoprt.ref.MOPTagWeakReference SafeSyncMap_iter_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
	static SafeSyncMapMonitor_Set SafeSyncMap_iter_Map_cacheset = null;
	static SafeSyncMapMonitor SafeSyncMap_iter_Map_cachenode = null;
	static javamoprt.map.MOPAbstractMap SafeSyncMap_mapSet__To__syncMap_mapSet_Map = new javamoprt.map.MOPMapOfSetMon(1);

	// Trees for References
	static javamoprt.map.MOPRefMap SafeSyncMap_Iterator_RefMap = new javamoprt.map.MOPTagRefMap();
	static javamoprt.map.MOPRefMap SafeSyncMap_Map_RefMap = new javamoprt.map.MOPTagRefMap();
	static javamoprt.map.MOPRefMap SafeSyncMap_Set_RefMap = new javamoprt.map.MOPTagRefMap();

	pointcut MOP_CommonPointCut() : !within(javamoprt.MOPObject+) && !adviceexecution();
	pointcut SafeSyncMap_sync() : (call(* Collections.synchr*(..))) && MOP_CommonPointCut();
	after () returning (Map syncMap) : SafeSyncMap_sync() {
		SafeSyncMap_activated = true;
		while (!SafeSyncMap_MOPLock.tryLock()) {
			Thread.yield();
		}
	    	memoryLogger.logMemoryConsumption(); // prm4j-eval
		SafeSyncMapMonitor mainMonitor = null;
		javamoprt.map.MOPMap mainMap = null;
		SafeSyncMapMonitor_Set mainSet = null;
		javamoprt.ref.MOPTagWeakReference TempRef_syncMap;

		// Cache Retrieval
		if (syncMap == SafeSyncMap_syncMap_Map_cachekey_0.get()) {
			TempRef_syncMap = SafeSyncMap_syncMap_Map_cachekey_0;

			mainSet = SafeSyncMap_syncMap_Map_cacheset;
			mainMonitor = SafeSyncMap_syncMap_Map_cachenode;
		} else {
			TempRef_syncMap = SafeSyncMap_Map_RefMap.getTagRef(syncMap);
		}

		if (mainSet == null || mainMonitor == null) {
			mainMap = SafeSyncMap_syncMap_mapSet_iter_Map;
			mainMonitor = (SafeSyncMapMonitor)mainMap.getNode(TempRef_syncMap);
			mainSet = (SafeSyncMapMonitor_Set)mainMap.getSet(TempRef_syncMap);
			if (mainSet == null){
				mainSet = new SafeSyncMapMonitor_Set();
				mainMap.putSet(TempRef_syncMap, mainSet);
			}

			if (mainMonitor == null) {
				mainMonitor = new SafeSyncMapMonitor();

				mainMonitor.MOPRef_syncMap = TempRef_syncMap;

				SafeSyncMap_syncMap_mapSet_iter_Map.putNode(TempRef_syncMap, mainMonitor);
				mainSet.add(mainMonitor);
				mainMonitor.tau = SafeSyncMap_timestamp;
				if (TempRef_syncMap.tau == -1){
					TempRef_syncMap.tau = SafeSyncMap_timestamp;
				}
				SafeSyncMap_timestamp++;
			}

			SafeSyncMap_syncMap_Map_cachekey_0 = TempRef_syncMap;
			SafeSyncMap_syncMap_Map_cacheset = mainSet;
			SafeSyncMap_syncMap_Map_cachenode = mainMonitor;
		}

		if(mainSet != null) {
			mainSet.event_sync(syncMap);
		}
		SafeSyncMap_MOPLock.unlock();
	}

	pointcut SafeSyncMap_createSet(Map syncMap) : (call(* Map+.keySet()) && target(syncMap)) && MOP_CommonPointCut();
	after (Map syncMap) returning (Set mapSet) : SafeSyncMap_createSet(syncMap) {
		while (!SafeSyncMap_MOPLock.tryLock()) {
			Thread.yield();
		}
	    	memoryLogger.logMemoryConsumption(); // prm4j-eval
		if (SafeSyncMap_activated) {
			Object obj;
			javamoprt.map.MOPMap tempMap;
			SafeSyncMapMonitor mainMonitor = null;
			SafeSyncMapMonitor origMonitor = null;
			javamoprt.map.MOPMap mainMap = null;
			javamoprt.map.MOPMap origMap = null;
			SafeSyncMapMonitor_Set mainSet = null;
			SafeSyncMapMonitor_Set monitors = null;
			javamoprt.ref.MOPTagWeakReference TempRef_syncMap;
			javamoprt.ref.MOPTagWeakReference TempRef_mapSet;

			// Cache Retrieval
			if (syncMap == SafeSyncMap_syncMap_mapSet_Map_cachekey_0.get() && mapSet == SafeSyncMap_syncMap_mapSet_Map_cachekey_1.get()) {
				TempRef_syncMap = SafeSyncMap_syncMap_mapSet_Map_cachekey_0;
				TempRef_mapSet = SafeSyncMap_syncMap_mapSet_Map_cachekey_1;

				mainSet = SafeSyncMap_syncMap_mapSet_Map_cacheset;
				mainMonitor = SafeSyncMap_syncMap_mapSet_Map_cachenode;
			} else {
				TempRef_syncMap = SafeSyncMap_Map_RefMap.getTagRef(syncMap);
				TempRef_mapSet = SafeSyncMap_Set_RefMap.getTagRef(mapSet);
			}

			if (mainSet == null || mainMonitor == null) {
				tempMap = SafeSyncMap_syncMap_mapSet_iter_Map;
				obj = tempMap.getMap(TempRef_syncMap);
				if (obj != null) {
					mainMap = (javamoprt.map.MOPAbstractMap)obj;
					mainMonitor = (SafeSyncMapMonitor)mainMap.getNode(TempRef_mapSet);
					mainSet = (SafeSyncMapMonitor_Set)mainMap.getSet(TempRef_mapSet);
				}

				if (mainMonitor == null) {
					if (mainMonitor == null) {
						origMap = SafeSyncMap_syncMap_mapSet_iter_Map;
						origMonitor = (SafeSyncMapMonitor)origMap.getNode(TempRef_syncMap);
						if (origMonitor != null) {
							boolean timeCheck = true;

							if (TempRef_mapSet.disable > origMonitor.tau) {
								timeCheck = false;
							}

							if (timeCheck) {
								mainMonitor = (SafeSyncMapMonitor)origMonitor.clone();
								mainMonitor.MOPRef_mapSet = TempRef_mapSet;
								if (TempRef_mapSet.tau == -1){
									TempRef_mapSet.tau = origMonitor.tau;
								}
								mainMap = SafeSyncMap_syncMap_mapSet_iter_Map;
								obj = mainMap.getMap(TempRef_syncMap);
								if (obj == null) {
									obj = new javamoprt.map.MOPMapOfSetMon(0);
									mainMap.putMap(TempRef_syncMap, obj);
								}
								mainMap = (javamoprt.map.MOPAbstractMap)obj;
								obj = mainMap.getSet(TempRef_mapSet);
								mainSet = (SafeSyncMapMonitor_Set)obj;
								if (mainSet == null) {
									mainSet = new SafeSyncMapMonitor_Set();
									mainMap.putSet(TempRef_mapSet, mainSet);
								}
								mainSet.add(mainMonitor);

								tempMap = SafeSyncMap_syncMap_mapSet_iter_Map;
								obj = tempMap.getSet(TempRef_syncMap);
								monitors = (SafeSyncMapMonitor_Set)obj;
								if (monitors == null) {
									monitors = new SafeSyncMapMonitor_Set();
									tempMap.putSet(TempRef_syncMap, monitors);
								}
								monitors.add(mainMonitor);

								tempMap = SafeSyncMap_mapSet__To__syncMap_mapSet_Map;
								obj = tempMap.getSet(TempRef_mapSet);
								monitors = (SafeSyncMapMonitor_Set)obj;
								if (monitors == null) {
									monitors = new SafeSyncMapMonitor_Set();
									tempMap.putSet(TempRef_mapSet, monitors);
								}
								monitors.add(mainMonitor);
							}
						}
					}

					TempRef_mapSet.disable = SafeSyncMap_timestamp;
					SafeSyncMap_timestamp++;
				}

				SafeSyncMap_syncMap_mapSet_Map_cachekey_0 = TempRef_syncMap;
				SafeSyncMap_syncMap_mapSet_Map_cachekey_1 = TempRef_mapSet;
				SafeSyncMap_syncMap_mapSet_Map_cacheset = mainSet;
				SafeSyncMap_syncMap_mapSet_Map_cachenode = mainMonitor;
			}

			if(mainSet != null) {
				mainSet.event_createSet(syncMap, mapSet);
			}
		}
		SafeSyncMap_MOPLock.unlock();
	}

	pointcut SafeSyncMap_syncCreateIter(Set mapSet) : (call(* Collection+.iterator()) && target(mapSet)) && MOP_CommonPointCut();
	after (Set mapSet) returning (Iterator iter) : SafeSyncMap_syncCreateIter(mapSet) {
		while (!SafeSyncMap_MOPLock.tryLock()) {
			Thread.yield();
		}
		//SafeSyncMap_syncCreateIter
	    	memoryLogger.logMemoryConsumption(); // prm4j-eval
		if (SafeSyncMap_activated) {
			Object obj;
			javamoprt.map.MOPMap tempMap;
			SafeSyncMapMonitor mainMonitor = null;
			SafeSyncMapMonitor origMonitor = null;
			SafeSyncMapMonitor lastMonitor = null;
			javamoprt.map.MOPMap mainMap = null;
			javamoprt.map.MOPMap origMap = null;
			javamoprt.map.MOPMap lastMap = null;
			SafeSyncMapMonitor_Set mainSet = null;
			SafeSyncMapMonitor_Set origSet = null;
			SafeSyncMapMonitor_Set monitors = null;
			javamoprt.ref.MOPTagWeakReference TempRef_syncMap;
			javamoprt.ref.MOPTagWeakReference TempRef_mapSet;
			javamoprt.ref.MOPTagWeakReference TempRef_iter;

			// Cache Retrieval
			if (mapSet == SafeSyncMap_mapSet_iter_Map_cachekey_1.get() && iter == SafeSyncMap_mapSet_iter_Map_cachekey_2.get()) {
				TempRef_mapSet = SafeSyncMap_mapSet_iter_Map_cachekey_1;
				TempRef_iter = SafeSyncMap_mapSet_iter_Map_cachekey_2;

				mainSet = SafeSyncMap_mapSet_iter_Map_cacheset;
				mainMonitor = SafeSyncMap_mapSet_iter_Map_cachenode;
			} else {
				TempRef_mapSet = SafeSyncMap_Set_RefMap.getTagRef(mapSet);
				TempRef_iter = SafeSyncMap_Iterator_RefMap.getTagRef(iter);
			}

			if (mainSet == null || mainMonitor == null) {
				tempMap = SafeSyncMap_mapSet_iter_Map;
				obj = tempMap.getMap(TempRef_mapSet);
				if (obj != null) {
					mainMap = (javamoprt.map.MOPAbstractMap)obj;
					mainMonitor = (SafeSyncMapMonitor)mainMap.getNode(TempRef_iter);
					mainSet = (SafeSyncMapMonitor_Set)mainMap.getSet(TempRef_iter);
				}

				if (mainMonitor == null) {
					origMap = SafeSyncMap_mapSet__To__syncMap_mapSet_Map;
					origSet = (SafeSyncMapMonitor_Set)origMap.getSet(TempRef_mapSet);
					if (origSet!= null) {
						int numAlive = 0;
						for(int i = 0; i < origSet.size; i++) {
							origMonitor = origSet.elementData[i];
							Map syncMap = (Map)origMonitor.MOPRef_syncMap.get();
							if (!origMonitor.MOP_terminated && syncMap != null) {
								origSet.elementData[numAlive] = origMonitor;
								numAlive++;

								TempRef_syncMap = origMonitor.MOPRef_syncMap;

								tempMap = SafeSyncMap_syncMap_mapSet_iter_Map;
								obj = tempMap.getMap(TempRef_syncMap);
								if (obj == null) {
									obj = new javamoprt.map.MOPMapOfAll(1);
									tempMap.putMap(TempRef_syncMap, obj);
								}
								tempMap = (javamoprt.map.MOPAbstractMap)obj;
								obj = tempMap.getMap(TempRef_mapSet);
								if (obj == null) {
									obj = new javamoprt.map.MOPMapOfMonitor(2);
									tempMap.putMap(TempRef_mapSet, obj);
								}
								lastMap = (javamoprt.map.MOPAbstractMap)obj;
								lastMonitor = (SafeSyncMapMonitor)lastMap.getNode(TempRef_iter);
								if (lastMonitor == null) {
									boolean timeCheck = true;

									if (TempRef_iter.disable > origMonitor.tau|| (TempRef_iter.tau > 0 && TempRef_iter.tau < origMonitor.tau)) {
										timeCheck = false;
									}

									if (timeCheck) {
										lastMonitor = (SafeSyncMapMonitor)origMonitor.clone();
										lastMonitor.MOPRef_iter = TempRef_iter;
										if (TempRef_iter.tau == -1){
											TempRef_iter.tau = origMonitor.tau;
										}
										lastMap.putNode(TempRef_iter, lastMonitor);

										mainMap = SafeSyncMap_mapSet_iter_Map;
										obj = mainMap.getMap(TempRef_mapSet);
										if (obj == null) {
											obj = new javamoprt.map.MOPMapOfSetMon(1);
											mainMap.putMap(TempRef_mapSet, obj);
										}
										mainMap = (javamoprt.map.MOPAbstractMap)obj;
										obj = mainMap.getSet(TempRef_iter);
										mainSet = (SafeSyncMapMonitor_Set)obj;
										if (mainSet == null) {
											mainSet = new SafeSyncMapMonitor_Set();
											mainMap.putSet(TempRef_iter, mainSet);
										}
										mainSet.add(lastMonitor);

										tempMap = SafeSyncMap_syncMap_mapSet_iter_Map;
										obj = tempMap.getSet(TempRef_syncMap);
										monitors = (SafeSyncMapMonitor_Set)obj;
										if (monitors == null) {
											monitors = new SafeSyncMapMonitor_Set();
											tempMap.putSet(TempRef_syncMap, monitors);
										}
										monitors.add(lastMonitor);

										tempMap = SafeSyncMap_syncMap_mapSet_iter_Map;
										obj = tempMap.getMap(TempRef_syncMap);
										if (obj == null) {
											obj = new javamoprt.map.MOPMapOfSetMon(0);
											tempMap.putMap(TempRef_syncMap, obj);
										}
										tempMap = (javamoprt.map.MOPAbstractMap)obj;
										obj = tempMap.getSet(TempRef_mapSet);
										monitors = (SafeSyncMapMonitor_Set)obj;
										if (monitors == null) {
											monitors = new SafeSyncMapMonitor_Set();
											tempMap.putSet(TempRef_mapSet, monitors);
										}
										monitors.add(lastMonitor);

										tempMap = SafeSyncMap_iter_Map;
										obj = tempMap.getSet(TempRef_iter);
										monitors = (SafeSyncMapMonitor_Set)obj;
										if (monitors == null) {
											monitors = new SafeSyncMapMonitor_Set();
											tempMap.putSet(TempRef_iter, monitors);
										}
										monitors.add(lastMonitor);
									}
								}
							}
						}

						for(int i = numAlive; i < origSet.size; i++) {
							origSet.elementData[i] = null;
						}
						origSet.size = numAlive;
					}

					TempRef_mapSet.disable = SafeSyncMap_timestamp;
					TempRef_iter.disable = SafeSyncMap_timestamp;
					SafeSyncMap_timestamp++;
				}

				SafeSyncMap_mapSet_iter_Map_cachekey_1 = TempRef_mapSet;
				SafeSyncMap_mapSet_iter_Map_cachekey_2 = TempRef_iter;
				SafeSyncMap_mapSet_iter_Map_cacheset = mainSet;
				SafeSyncMap_mapSet_iter_Map_cachenode = mainMonitor;
			}

			if(mainSet != null) {
				mainSet.event_syncCreateIter(mapSet, iter);
			}
		}
		//SafeSyncMap_asyncCreateIter
		if (SafeSyncMap_activated) {
			Object obj;
			javamoprt.map.MOPMap tempMap;
			SafeSyncMapMonitor mainMonitor = null;
			SafeSyncMapMonitor origMonitor = null;
			SafeSyncMapMonitor lastMonitor = null;
			javamoprt.map.MOPMap mainMap = null;
			javamoprt.map.MOPMap origMap = null;
			javamoprt.map.MOPMap lastMap = null;
			SafeSyncMapMonitor_Set mainSet = null;
			SafeSyncMapMonitor_Set origSet = null;
			SafeSyncMapMonitor_Set monitors = null;
			javamoprt.ref.MOPTagWeakReference TempRef_syncMap;
			javamoprt.ref.MOPTagWeakReference TempRef_mapSet;
			javamoprt.ref.MOPTagWeakReference TempRef_iter;

			// Cache Retrieval
			if (mapSet == SafeSyncMap_mapSet_iter_Map_cachekey_1.get() && iter == SafeSyncMap_mapSet_iter_Map_cachekey_2.get()) {
				TempRef_mapSet = SafeSyncMap_mapSet_iter_Map_cachekey_1;
				TempRef_iter = SafeSyncMap_mapSet_iter_Map_cachekey_2;

				mainSet = SafeSyncMap_mapSet_iter_Map_cacheset;
				mainMonitor = SafeSyncMap_mapSet_iter_Map_cachenode;
			} else {
				TempRef_mapSet = SafeSyncMap_Set_RefMap.getTagRef(mapSet);
				TempRef_iter = SafeSyncMap_Iterator_RefMap.getTagRef(iter);
			}

			if (mainSet == null || mainMonitor == null) {
				tempMap = SafeSyncMap_mapSet_iter_Map;
				obj = tempMap.getMap(TempRef_mapSet);
				if (obj != null) {
					mainMap = (javamoprt.map.MOPAbstractMap)obj;
					mainMonitor = (SafeSyncMapMonitor)mainMap.getNode(TempRef_iter);
					mainSet = (SafeSyncMapMonitor_Set)mainMap.getSet(TempRef_iter);
				}

				if (mainMonitor == null) {
					origMap = SafeSyncMap_mapSet__To__syncMap_mapSet_Map;
					origSet = (SafeSyncMapMonitor_Set)origMap.getSet(TempRef_mapSet);
					if (origSet!= null) {
						int numAlive = 0;
						for(int i = 0; i < origSet.size; i++) {
							origMonitor = origSet.elementData[i];
							Map syncMap = (Map)origMonitor.MOPRef_syncMap.get();
							if (!origMonitor.MOP_terminated && syncMap != null) {
								origSet.elementData[numAlive] = origMonitor;
								numAlive++;

								TempRef_syncMap = origMonitor.MOPRef_syncMap;

								tempMap = SafeSyncMap_syncMap_mapSet_iter_Map;
								obj = tempMap.getMap(TempRef_syncMap);
								if (obj == null) {
									obj = new javamoprt.map.MOPMapOfAll(1);
									tempMap.putMap(TempRef_syncMap, obj);
								}
								tempMap = (javamoprt.map.MOPAbstractMap)obj;
								obj = tempMap.getMap(TempRef_mapSet);
								if (obj == null) {
									obj = new javamoprt.map.MOPMapOfMonitor(2);
									tempMap.putMap(TempRef_mapSet, obj);
								}
								lastMap = (javamoprt.map.MOPAbstractMap)obj;
								lastMonitor = (SafeSyncMapMonitor)lastMap.getNode(TempRef_iter);
								if (lastMonitor == null) {
									boolean timeCheck = true;

									if (TempRef_iter.disable > origMonitor.tau|| (TempRef_iter.tau > 0 && TempRef_iter.tau < origMonitor.tau)) {
										timeCheck = false;
									}

									if (timeCheck) {
										lastMonitor = (SafeSyncMapMonitor)origMonitor.clone();
										lastMonitor.MOPRef_iter = TempRef_iter;
										if (TempRef_iter.tau == -1){
											TempRef_iter.tau = origMonitor.tau;
										}
										lastMap.putNode(TempRef_iter, lastMonitor);

										mainMap = SafeSyncMap_mapSet_iter_Map;
										obj = mainMap.getMap(TempRef_mapSet);
										if (obj == null) {
											obj = new javamoprt.map.MOPMapOfSetMon(1);
											mainMap.putMap(TempRef_mapSet, obj);
										}
										mainMap = (javamoprt.map.MOPAbstractMap)obj;
										obj = mainMap.getSet(TempRef_iter);
										mainSet = (SafeSyncMapMonitor_Set)obj;
										if (mainSet == null) {
											mainSet = new SafeSyncMapMonitor_Set();
											mainMap.putSet(TempRef_iter, mainSet);
										}
										mainSet.add(lastMonitor);

										tempMap = SafeSyncMap_syncMap_mapSet_iter_Map;
										obj = tempMap.getSet(TempRef_syncMap);
										monitors = (SafeSyncMapMonitor_Set)obj;
										if (monitors == null) {
											monitors = new SafeSyncMapMonitor_Set();
											tempMap.putSet(TempRef_syncMap, monitors);
										}
										monitors.add(lastMonitor);

										tempMap = SafeSyncMap_syncMap_mapSet_iter_Map;
										obj = tempMap.getMap(TempRef_syncMap);
										if (obj == null) {
											obj = new javamoprt.map.MOPMapOfSetMon(0);
											tempMap.putMap(TempRef_syncMap, obj);
										}
										tempMap = (javamoprt.map.MOPAbstractMap)obj;
										obj = tempMap.getSet(TempRef_mapSet);
										monitors = (SafeSyncMapMonitor_Set)obj;
										if (monitors == null) {
											monitors = new SafeSyncMapMonitor_Set();
											tempMap.putSet(TempRef_mapSet, monitors);
										}
										monitors.add(lastMonitor);

										tempMap = SafeSyncMap_iter_Map;
										obj = tempMap.getSet(TempRef_iter);
										monitors = (SafeSyncMapMonitor_Set)obj;
										if (monitors == null) {
											monitors = new SafeSyncMapMonitor_Set();
											tempMap.putSet(TempRef_iter, monitors);
										}
										monitors.add(lastMonitor);
									}
								}
							}
						}

						for(int i = numAlive; i < origSet.size; i++) {
							origSet.elementData[i] = null;
						}
						origSet.size = numAlive;
					}

					TempRef_mapSet.disable = SafeSyncMap_timestamp;
					TempRef_iter.disable = SafeSyncMap_timestamp;
					SafeSyncMap_timestamp++;
				}

				SafeSyncMap_mapSet_iter_Map_cachekey_1 = TempRef_mapSet;
				SafeSyncMap_mapSet_iter_Map_cachekey_2 = TempRef_iter;
				SafeSyncMap_mapSet_iter_Map_cacheset = mainSet;
				SafeSyncMap_mapSet_iter_Map_cachenode = mainMonitor;
			}

			if(mainSet != null) {
				mainSet.event_asyncCreateIter(mapSet, iter);
			}
		}
		SafeSyncMap_MOPLock.unlock();
	}

	pointcut SafeSyncMap_accessIter(Iterator iter) : (call(* Iterator.*(..)) && target(iter)) && MOP_CommonPointCut();
	before (Iterator iter) : SafeSyncMap_accessIter(iter) {
		while (!SafeSyncMap_MOPLock.tryLock()) {
			Thread.yield();
		}
	    	memoryLogger.logMemoryConsumption(); // prm4j-eval
		if (SafeSyncMap_activated) {
			SafeSyncMapMonitor mainMonitor = null;
			javamoprt.map.MOPMap mainMap = null;
			SafeSyncMapMonitor_Set mainSet = null;
			javamoprt.ref.MOPTagWeakReference TempRef_iter;

			// Cache Retrieval
			if (iter == SafeSyncMap_iter_Map_cachekey_2.get()) {
				TempRef_iter = SafeSyncMap_iter_Map_cachekey_2;

				mainSet = SafeSyncMap_iter_Map_cacheset;
				mainMonitor = SafeSyncMap_iter_Map_cachenode;
			} else {
				TempRef_iter = SafeSyncMap_Iterator_RefMap.getTagRef(iter);
			}

			if (mainSet == null || mainMonitor == null) {
				mainMap = SafeSyncMap_iter_Map;
				mainMonitor = (SafeSyncMapMonitor)mainMap.getNode(TempRef_iter);
				mainSet = (SafeSyncMapMonitor_Set)mainMap.getSet(TempRef_iter);

				if (mainMonitor == null) {

					TempRef_iter.disable = SafeSyncMap_timestamp;
					SafeSyncMap_timestamp++;
				}

				SafeSyncMap_iter_Map_cachekey_2 = TempRef_iter;
				SafeSyncMap_iter_Map_cacheset = mainSet;
				SafeSyncMap_iter_Map_cachenode = mainMonitor;
			}

			if(mainSet != null) {
				mainSet.event_accessIter(iter);
			}
		}
		SafeSyncMap_MOPLock.unlock();
	}
	
	/**
	 *  prm4j-eval: resets the parametric monitor
	 */
	after() : execution (* org.dacapo.harness.Callback+.stop()) {
		System.out.println("[JavaMOP.SafeSyncMap] Resetting... Reported " + SafeSyncMapMonitor.MATCHES.get() + " matches.");

		memoryLogger.reallyLogMemoryConsumption(); // so we have at least two values
		
		SafeSyncMap_timestamp = 1;

		SafeSyncMap_activated = false;
		
		// Declarations for Indexing Trees
		SafeSyncMap_mapSet_iter_Map = new javamoprt.map.MOPMapOfAll(1);
		SafeSyncMap_mapSet_iter_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncMap_mapSet_iter_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncMap_mapSet_iter_Map_cacheset = null;
		SafeSyncMap_mapSet_iter_Map_cachenode = null;
		SafeSyncMap_syncMap_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncMap_syncMap_Map_cacheset = null;
		SafeSyncMap_syncMap_Map_cachenode = null;
		SafeSyncMap_syncMap_mapSet_iter_Map = new javamoprt.map.MOPMapOfAll(0);
		SafeSyncMap_syncMap_mapSet_iter_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncMap_syncMap_mapSet_iter_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncMap_syncMap_mapSet_iter_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncMap_syncMap_mapSet_iter_Map_cachenode = null;
		SafeSyncMap_syncMap_mapSet_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncMap_syncMap_mapSet_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncMap_syncMap_mapSet_Map_cacheset = null;
		SafeSyncMap_syncMap_mapSet_Map_cachenode = null;
		SafeSyncMap_iter_Map = new javamoprt.map.MOPMapOfSetMon(2);
		SafeSyncMap_iter_Map_cachekey_2 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncMap_iter_Map_cacheset = null;
		SafeSyncMap_iter_Map_cachenode = null;
		SafeSyncMap_mapSet__To__syncMap_mapSet_Map = new javamoprt.map.MOPMapOfSetMon(1);

		// Trees for References
		SafeSyncMap_Iterator_RefMap = new javamoprt.map.MOPTagRefMap();
		SafeSyncMap_Map_RefMap = new javamoprt.map.MOPTagRefMap();
		SafeSyncMap_Set_RefMap = new javamoprt.map.MOPTagRefMap();
		
		SafeSyncMapMapManager = new javamoprt.map.MOPMapManager();
		SafeSyncMapMapManager.start();
		
		memoryLogger.writeToFile(SafeSyncMapMonitor.MATCHES.get());
		
		SafeSyncMapMonitor.MATCHES.set(0); // reset counter
		
		System.gc();
		System.gc();
	}


}

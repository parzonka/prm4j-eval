package mop;
import java.io.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.*;
import javamoprt.*;
import java.lang.ref.*;

class SafeSyncCollectionMonitor_Set extends javamoprt.MOPSet {
	protected SafeSyncCollectionMonitor[] elementData;

	public SafeSyncCollectionMonitor_Set(){
		this.size = 0;
		this.elementData = new SafeSyncCollectionMonitor[4];
	}

	public final int size(){
		while(size > 0 && elementData[size-1].MOP_terminated) {
			elementData[--size] = null;
		}
		return size;
	}

	public final boolean add(MOPMonitor e){
		ensureCapacity();
		elementData[size++] = (SafeSyncCollectionMonitor)e;
		return true;
	}

	public final void endObject(int idnum){
		int numAlive = 0;
		for(int i = 0; i < size; i++){
			SafeSyncCollectionMonitor monitor = elementData[i];
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
			SafeSyncCollectionMonitor[] oldData = elementData;
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
			SafeSyncCollectionMonitor monitor = (SafeSyncCollectionMonitor)elementData[i];
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

	public final void event_sync(Object c) {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SafeSyncCollectionMonitor monitor = (SafeSyncCollectionMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_sync(c);
				if(monitor.Prop_1_Category_match) {
					monitor.Prop_1_handler_match(c, null);
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_syncCreateIter(Object c, Iterator iter) {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SafeSyncCollectionMonitor monitor = (SafeSyncCollectionMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_syncCreateIter(c, iter);
				if(monitor.Prop_1_Category_match) {
					monitor.Prop_1_handler_match(c, iter);
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elementData[i] = null;
		}
		size = numAlive;
	}

	public final void event_asyncCreateIter(Object c, Iterator iter) {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SafeSyncCollectionMonitor monitor = (SafeSyncCollectionMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_asyncCreateIter(c, iter);
				if(monitor.Prop_1_Category_match) {
					monitor.Prop_1_handler_match(c, iter);
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
			SafeSyncCollectionMonitor monitor = (SafeSyncCollectionMonitor)this.elementData[i];
			if(!monitor.MOP_terminated){
				elementData[numAlive] = monitor;
				numAlive++;

				monitor.Prop_1_event_accessIter(iter);
				if(monitor.MOP_conditionFail){
					monitor.MOP_conditionFail = false;
				} else {
					if(monitor.Prop_1_Category_match) {
						monitor.Prop_1_handler_match(null, iter);
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

class SafeSyncCollectionMonitor extends javamoprt.MOPMonitor implements Cloneable, javamoprt.MOPObject {
    
	/**
	 *  prm4j-eval: Measures number of matches.
	 */
	static AtomicInteger MATCHES = new AtomicInteger();  // prm4j-eval
	
	public long tau = -1;
	public Object clone() {
		try {
			SafeSyncCollectionMonitor ret = (SafeSyncCollectionMonitor) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	Object c;

	boolean MOP_conditionFail = false;
	int Prop_1_state;
	static final int Prop_1_transition_sync[] = {3, 4, 4, 4, 4};;
	static final int Prop_1_transition_syncCreateIter[] = {4, 4, 4, 2, 4};;
	static final int Prop_1_transition_asyncCreateIter[] = {4, 4, 4, 1, 4};;
	static final int Prop_1_transition_accessIter[] = {4, 4, 1, 4, 4};;

	boolean Prop_1_Category_match = false;

	public SafeSyncCollectionMonitor () {
		Prop_1_state = 0;

	}

	public final void Prop_1_event_sync(Object c) {
		MOP_lastevent = 0;

		Prop_1_state = Prop_1_transition_sync[Prop_1_state];
		Prop_1_Category_match = Prop_1_state == 1;
		{
			this.c = c;
		}
	}

	public final void Prop_1_event_syncCreateIter(Object c, Iterator iter) {
		MOP_lastevent = 1;

		Prop_1_state = Prop_1_transition_syncCreateIter[Prop_1_state];
		Prop_1_Category_match = Prop_1_state == 1;
	}

	public final void Prop_1_event_asyncCreateIter(Object c, Iterator iter) {
		MOP_lastevent = 2;

		Prop_1_state = Prop_1_transition_asyncCreateIter[Prop_1_state];
		Prop_1_Category_match = Prop_1_state == 1;
	}

	public final void Prop_1_event_accessIter(Iterator iter) {
		if (!(!Thread.holdsLock(this.c)
		)) {
			MOP_conditionFail = true;
			return;
		}
		MOP_lastevent = 3;

		Prop_1_state = Prop_1_transition_accessIter[Prop_1_state];
		Prop_1_Category_match = Prop_1_state == 1;
	}

	public final void Prop_1_handler_match (Object c, Iterator iter){
		{
		    MATCHES.incrementAndGet(); // prm4j-eval
		}

	}

	public final void reset() {
		MOP_lastevent = -1;
		Prop_1_state = 0;
		Prop_1_Category_match = false;
	}

	public javamoprt.ref.MOPTagWeakReference MOPRef_c;
	public javamoprt.ref.MOPTagWeakReference MOPRef_iter;

	//alive_parameters_0 = [Object c, Iterator iter]
	public boolean alive_parameters_0 = true;
	//alive_parameters_1 = [Iterator iter]
	public boolean alive_parameters_1 = true;

	public final void endObject(int idnum){
		switch(idnum){
			case 0:
			alive_parameters_0 = false;
			break;
			case 1:
			alive_parameters_0 = false;
			alive_parameters_1 = false;
			break;
		}
		switch(MOP_lastevent) {
			case -1:
			return;
			case 0:
			//sync
			//alive_c && alive_iter
			if(!(alive_parameters_0)){
				MOP_terminated = true;
				return;
			}
			break;

			case 1:
			//syncCreateIter
			//alive_iter
			if(!(alive_parameters_1)){
				MOP_terminated = true;
				return;
			}
			break;

			case 2:
			//asyncCreateIter
			return;
			case 3:
			//accessIter
			return;
		}
		return;
	}

}

public aspect SafeSyncCollectionMonitorAspect implements javamoprt.MOPObject {
	javamoprt.map.MOPMapManager SafeSyncCollectionMapManager;
	private final MemoryLogger memoryLogger; // prm4j-eval
	public SafeSyncCollectionMonitorAspect(){
		SafeSyncCollectionMapManager = new javamoprt.map.MOPMapManager();
		SafeSyncCollectionMapManager.start();
		System.out.println("[JavaMOP.SafeSyncCollection] Started"); // prm4j-eval
		memoryLogger = new MemoryLogger(); // prm4j-eval
	}

	// Declarations for the Lock
	static ReentrantLock SafeSyncCollection_MOPLock = new ReentrantLock();
	static Condition SafeSyncCollection_MOPLock_cond = SafeSyncCollection_MOPLock.newCondition();

	// Declarations for Timestamps
	static long SafeSyncCollection_timestamp = 1;

	static boolean SafeSyncCollection_activated = false;

	// Declarations for Indexing Trees
	static javamoprt.ref.MOPTagWeakReference SafeSyncCollection_c_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
	static SafeSyncCollectionMonitor_Set SafeSyncCollection_c_Map_cacheset = null;
	static SafeSyncCollectionMonitor SafeSyncCollection_c_Map_cachenode = null;
	static javamoprt.map.MOPAbstractMap SafeSyncCollection_c_iter_Map = new javamoprt.map.MOPMapOfAll(0);
	static javamoprt.ref.MOPTagWeakReference SafeSyncCollection_c_iter_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
	static javamoprt.ref.MOPTagWeakReference SafeSyncCollection_c_iter_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
	static SafeSyncCollectionMonitor SafeSyncCollection_c_iter_Map_cachenode = null;
	static javamoprt.map.MOPAbstractMap SafeSyncCollection_iter_Map = new javamoprt.map.MOPMapOfSetMon(1);
	static javamoprt.ref.MOPTagWeakReference SafeSyncCollection_iter_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
	static SafeSyncCollectionMonitor_Set SafeSyncCollection_iter_Map_cacheset = null;
	static SafeSyncCollectionMonitor SafeSyncCollection_iter_Map_cachenode = null;

	// Trees for References
	static javamoprt.map.MOPRefMap SafeSyncCollection_Iterator_RefMap = new javamoprt.map.MOPTagRefMap();
	static javamoprt.map.MOPRefMap SafeSyncCollection_Object_RefMap = new javamoprt.map.MOPTagRefMap();

	pointcut MOP_CommonPointCut() : !within(javamoprt.MOPObject+) && !adviceexecution();
	pointcut SafeSyncCollection_sync() : (call(* Collections.synchr*(..))) && MOP_CommonPointCut();
	after () returning (Object c) : SafeSyncCollection_sync() {
		SafeSyncCollection_activated = true;
		while (!SafeSyncCollection_MOPLock.tryLock()) {
			Thread.yield();
		}
		memoryLogger.logMemoryConsumption(); // prm4j-eval
		SafeSyncCollectionMonitor mainMonitor = null;
		javamoprt.map.MOPMap mainMap = null;
		SafeSyncCollectionMonitor_Set mainSet = null;
		javamoprt.ref.MOPTagWeakReference TempRef_c;

		// Cache Retrieval
		if (c == SafeSyncCollection_c_Map_cachekey_0.get()) {
			TempRef_c = SafeSyncCollection_c_Map_cachekey_0;

			mainSet = SafeSyncCollection_c_Map_cacheset;
			mainMonitor = SafeSyncCollection_c_Map_cachenode;
		} else {
			TempRef_c = SafeSyncCollection_Object_RefMap.getTagRef(c);
		}

		if (mainSet == null || mainMonitor == null) {
			mainMap = SafeSyncCollection_c_iter_Map;
			mainMonitor = (SafeSyncCollectionMonitor)mainMap.getNode(TempRef_c);
			mainSet = (SafeSyncCollectionMonitor_Set)mainMap.getSet(TempRef_c);
			if (mainSet == null){
				mainSet = new SafeSyncCollectionMonitor_Set();
				mainMap.putSet(TempRef_c, mainSet);
			}

			if (mainMonitor == null) {
				mainMonitor = new SafeSyncCollectionMonitor();

				mainMonitor.MOPRef_c = TempRef_c;

				SafeSyncCollection_c_iter_Map.putNode(TempRef_c, mainMonitor);
				mainSet.add(mainMonitor);
				mainMonitor.tau = SafeSyncCollection_timestamp;
				if (TempRef_c.tau == -1){
					TempRef_c.tau = SafeSyncCollection_timestamp;
				}
				SafeSyncCollection_timestamp++;
			}

			SafeSyncCollection_c_Map_cachekey_0 = TempRef_c;
			SafeSyncCollection_c_Map_cacheset = mainSet;
			SafeSyncCollection_c_Map_cachenode = mainMonitor;
		}

		if(mainSet != null) {
			mainSet.event_sync(c);
		}
		SafeSyncCollection_MOPLock.unlock();
	}

	pointcut SafeSyncCollection_syncCreateIter(Object c) : (call(* Collection+.iterator()) && target(c) && if(Thread.holdsLock(c))) && MOP_CommonPointCut();
	after (Object c) returning (Iterator iter) : SafeSyncCollection_syncCreateIter(c) {
		while (!SafeSyncCollection_MOPLock.tryLock()) {
			Thread.yield();
		}
		memoryLogger.logMemoryConsumption(); // prm4j-eval
		if (SafeSyncCollection_activated) {
			Object obj;
			javamoprt.map.MOPMap tempMap;
			SafeSyncCollectionMonitor mainMonitor = null;
			SafeSyncCollectionMonitor origMonitor = null;
			javamoprt.map.MOPMap mainMap = null;
			javamoprt.map.MOPMap origMap = null;
			SafeSyncCollectionMonitor_Set monitors = null;
			javamoprt.ref.MOPTagWeakReference TempRef_c;
			javamoprt.ref.MOPTagWeakReference TempRef_iter;

			// Cache Retrieval
			if (c == SafeSyncCollection_c_iter_Map_cachekey_0.get() && iter == SafeSyncCollection_c_iter_Map_cachekey_1.get()) {
				TempRef_c = SafeSyncCollection_c_iter_Map_cachekey_0;
				TempRef_iter = SafeSyncCollection_c_iter_Map_cachekey_1;

				mainMonitor = SafeSyncCollection_c_iter_Map_cachenode;
			} else {
				TempRef_c = SafeSyncCollection_Object_RefMap.getTagRef(c);
				TempRef_iter = SafeSyncCollection_Iterator_RefMap.getTagRef(iter);
			}

			if (mainMonitor == null) {
				tempMap = SafeSyncCollection_c_iter_Map;
				obj = tempMap.getMap(TempRef_c);
				if (obj != null) {
					mainMap = (javamoprt.map.MOPAbstractMap)obj;
					mainMonitor = (SafeSyncCollectionMonitor)mainMap.getNode(TempRef_iter);
				}

				if (mainMonitor == null) {
					if (mainMonitor == null) {
						origMap = SafeSyncCollection_c_iter_Map;
						origMonitor = (SafeSyncCollectionMonitor)origMap.getNode(TempRef_c);
						if (origMonitor != null) {
							boolean timeCheck = true;

							if (TempRef_iter.disable > origMonitor.tau) {
								timeCheck = false;
							}

							if (timeCheck) {
								mainMonitor = (SafeSyncCollectionMonitor)origMonitor.clone();
								mainMonitor.MOPRef_iter = TempRef_iter;
								if (TempRef_iter.tau == -1){
									TempRef_iter.tau = origMonitor.tau;
								}
								mainMap = SafeSyncCollection_c_iter_Map;
								obj = mainMap.getMap(TempRef_c);
								if (obj == null) {
									obj = new javamoprt.map.MOPMapOfMonitor(1);
									mainMap.putMap(TempRef_c, obj);
								}
								mainMap = (javamoprt.map.MOPAbstractMap)obj;
								mainMap.putNode(TempRef_iter, mainMonitor);

								tempMap = SafeSyncCollection_c_iter_Map;
								obj = tempMap.getSet(TempRef_c);
								monitors = (SafeSyncCollectionMonitor_Set)obj;
								if (monitors == null) {
									monitors = new SafeSyncCollectionMonitor_Set();
									tempMap.putSet(TempRef_c, monitors);
								}
								monitors.add(mainMonitor);

								tempMap = SafeSyncCollection_iter_Map;
								obj = tempMap.getSet(TempRef_iter);
								monitors = (SafeSyncCollectionMonitor_Set)obj;
								if (monitors == null) {
									monitors = new SafeSyncCollectionMonitor_Set();
									tempMap.putSet(TempRef_iter, monitors);
								}
								monitors.add(mainMonitor);
							}
						}
					}

					TempRef_iter.disable = SafeSyncCollection_timestamp;
					SafeSyncCollection_timestamp++;
				}

				SafeSyncCollection_c_iter_Map_cachekey_0 = TempRef_c;
				SafeSyncCollection_c_iter_Map_cachekey_1 = TempRef_iter;
				SafeSyncCollection_c_iter_Map_cachenode = mainMonitor;
			}

			if (mainMonitor != null ) {
				mainMonitor.Prop_1_event_syncCreateIter(c, iter);
				if(mainMonitor.Prop_1_Category_match) {
					mainMonitor.Prop_1_handler_match(c, iter);
				}
			}
		}
		SafeSyncCollection_MOPLock.unlock();
	}

	pointcut SafeSyncCollection_asyncCreateIter(Object c) : (call(* Collection+.iterator()) && target(c) && if(!Thread.holdsLock(c))) && MOP_CommonPointCut();
	after (Object c) returning (Iterator iter) : SafeSyncCollection_asyncCreateIter(c) {
		while (!SafeSyncCollection_MOPLock.tryLock()) {
			Thread.yield();
		}
		memoryLogger.logMemoryConsumption(); // prm4j-eval
		if (SafeSyncCollection_activated) {
			Object obj;
			javamoprt.map.MOPMap tempMap;
			SafeSyncCollectionMonitor mainMonitor = null;
			SafeSyncCollectionMonitor origMonitor = null;
			javamoprt.map.MOPMap mainMap = null;
			javamoprt.map.MOPMap origMap = null;
			SafeSyncCollectionMonitor_Set monitors = null;
			javamoprt.ref.MOPTagWeakReference TempRef_c;
			javamoprt.ref.MOPTagWeakReference TempRef_iter;

			// Cache Retrieval
			if (c == SafeSyncCollection_c_iter_Map_cachekey_0.get() && iter == SafeSyncCollection_c_iter_Map_cachekey_1.get()) {
				TempRef_c = SafeSyncCollection_c_iter_Map_cachekey_0;
				TempRef_iter = SafeSyncCollection_c_iter_Map_cachekey_1;

				mainMonitor = SafeSyncCollection_c_iter_Map_cachenode;
			} else {
				TempRef_c = SafeSyncCollection_Object_RefMap.getTagRef(c);
				TempRef_iter = SafeSyncCollection_Iterator_RefMap.getTagRef(iter);
			}

			if (mainMonitor == null) {
				tempMap = SafeSyncCollection_c_iter_Map;
				obj = tempMap.getMap(TempRef_c);
				if (obj != null) {
					mainMap = (javamoprt.map.MOPAbstractMap)obj;
					mainMonitor = (SafeSyncCollectionMonitor)mainMap.getNode(TempRef_iter);
				}

				if (mainMonitor == null) {
					if (mainMonitor == null) {
						origMap = SafeSyncCollection_c_iter_Map;
						origMonitor = (SafeSyncCollectionMonitor)origMap.getNode(TempRef_c);
						if (origMonitor != null) {
							boolean timeCheck = true;

							if (TempRef_iter.disable > origMonitor.tau) {
								timeCheck = false;
							}

							if (timeCheck) {
								mainMonitor = (SafeSyncCollectionMonitor)origMonitor.clone();
								mainMonitor.MOPRef_iter = TempRef_iter;
								if (TempRef_iter.tau == -1){
									TempRef_iter.tau = origMonitor.tau;
								}
								mainMap = SafeSyncCollection_c_iter_Map;
								obj = mainMap.getMap(TempRef_c);
								if (obj == null) {
									obj = new javamoprt.map.MOPMapOfMonitor(1);
									mainMap.putMap(TempRef_c, obj);
								}
								mainMap = (javamoprt.map.MOPAbstractMap)obj;
								mainMap.putNode(TempRef_iter, mainMonitor);

								tempMap = SafeSyncCollection_c_iter_Map;
								obj = tempMap.getSet(TempRef_c);
								monitors = (SafeSyncCollectionMonitor_Set)obj;
								if (monitors == null) {
									monitors = new SafeSyncCollectionMonitor_Set();
									tempMap.putSet(TempRef_c, monitors);
								}
								monitors.add(mainMonitor);

								tempMap = SafeSyncCollection_iter_Map;
								obj = tempMap.getSet(TempRef_iter);
								monitors = (SafeSyncCollectionMonitor_Set)obj;
								if (monitors == null) {
									monitors = new SafeSyncCollectionMonitor_Set();
									tempMap.putSet(TempRef_iter, monitors);
								}
								monitors.add(mainMonitor);
							}
						}
					}

					TempRef_iter.disable = SafeSyncCollection_timestamp;
					SafeSyncCollection_timestamp++;
				}

				SafeSyncCollection_c_iter_Map_cachekey_0 = TempRef_c;
				SafeSyncCollection_c_iter_Map_cachekey_1 = TempRef_iter;
				SafeSyncCollection_c_iter_Map_cachenode = mainMonitor;
			}

			if (mainMonitor != null ) {
				mainMonitor.Prop_1_event_asyncCreateIter(c, iter);
				if(mainMonitor.Prop_1_Category_match) {
					mainMonitor.Prop_1_handler_match(c, iter);
				}
			}
		}
		SafeSyncCollection_MOPLock.unlock();
	}

	pointcut SafeSyncCollection_accessIter(Iterator iter) : (call(* Iterator.*(..)) && target(iter)) && MOP_CommonPointCut();
	before (Iterator iter) : SafeSyncCollection_accessIter(iter) {
		while (!SafeSyncCollection_MOPLock.tryLock()) {
			Thread.yield();
		}
		memoryLogger.logMemoryConsumption(); // prm4j-eval
		if (SafeSyncCollection_activated) {
			SafeSyncCollectionMonitor mainMonitor = null;
			javamoprt.map.MOPMap mainMap = null;
			SafeSyncCollectionMonitor_Set mainSet = null;
			javamoprt.ref.MOPTagWeakReference TempRef_iter;

			// Cache Retrieval
			if (iter == SafeSyncCollection_iter_Map_cachekey_1.get()) {
				TempRef_iter = SafeSyncCollection_iter_Map_cachekey_1;

				mainSet = SafeSyncCollection_iter_Map_cacheset;
				mainMonitor = SafeSyncCollection_iter_Map_cachenode;
			} else {
				TempRef_iter = SafeSyncCollection_Iterator_RefMap.getTagRef(iter);
			}

			if (mainSet == null || mainMonitor == null) {
				mainMap = SafeSyncCollection_iter_Map;
				mainMonitor = (SafeSyncCollectionMonitor)mainMap.getNode(TempRef_iter);
				mainSet = (SafeSyncCollectionMonitor_Set)mainMap.getSet(TempRef_iter);

				if (mainMonitor == null) {

					TempRef_iter.disable = SafeSyncCollection_timestamp;
					SafeSyncCollection_timestamp++;
				}

				SafeSyncCollection_iter_Map_cachekey_1 = TempRef_iter;
				SafeSyncCollection_iter_Map_cacheset = mainSet;
				SafeSyncCollection_iter_Map_cachenode = mainMonitor;
			}

			if(mainSet != null) {
				mainSet.event_accessIter(iter);
			}
		}
		SafeSyncCollection_MOPLock.unlock();
	}
	
	/**
	 *  prm4j-eval: resets the parametric monitor
	 */
	after() : execution (* org.dacapo.harness.Callback+.stop()) {
		System.out.println("[JavaMOP.SafeSyncCollection] Resetting... Reported " + SafeSyncCollectionMonitor.MATCHES.get() + " matches.");
		
		memoryLogger.reallyLogMemoryConsumption(); // so we have at least two values
		
		SafeSyncCollection_timestamp = 1;

		SafeSyncCollection_activated = false;
		
		// Indexing Trees
		SafeSyncCollection_c_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncCollection_c_Map_cacheset = null;
		SafeSyncCollection_c_Map_cachenode = null;
		SafeSyncCollection_c_iter_Map = new javamoprt.map.MOPMapOfAll(0);
		SafeSyncCollection_c_iter_Map_cachekey_0 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncCollection_c_iter_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncCollection_c_iter_Map_cachenode = null;
		SafeSyncCollection_iter_Map = new javamoprt.map.MOPMapOfSetMon(1);
		SafeSyncCollection_iter_Map_cachekey_1 = javamoprt.map.MOPTagRefMap.NULRef;
		SafeSyncCollection_iter_Map_cacheset = null;
		SafeSyncCollection_iter_Map_cachenode = null;

		// Trees for References
		SafeSyncCollection_Iterator_RefMap = new javamoprt.map.MOPTagRefMap();
		SafeSyncCollection_Object_RefMap = new javamoprt.map.MOPTagRefMap();
		
		SafeSyncCollectionMapManager = new javamoprt.map.MOPMapManager();
		SafeSyncCollectionMapManager.start();
		
		memoryLogger.writeToFile(SafeSyncCollectionMonitor.MATCHES.get());
		
		SafeSyncCollectionMonitor.MATCHES.set(0); // reset counter
		
		System.gc();
		System.gc();
	}


}

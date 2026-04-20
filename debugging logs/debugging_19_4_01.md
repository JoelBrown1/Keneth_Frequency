-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             keneth_frequency [28377]
Path:                /Users/USER/Documents/*/keneth_frequency.app/Contents/MacOS/keneth_frequency
Identifier:          com.example.kenethFrequency
Version:             1.0.0 (1)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      launchd [1]
Coalition:           com.example.kenethFrequency [10176]
User ID:             501

Date/Time:           2026-04-19 18:23:19.2651 -0400
Launch Time:         2026-04-19 18:22:17.2746 -0400
Hardware Model:      Mac17,4
OS Version:          macOS 26.4.1 (25E253)
Release Type:        User

Crash Reporter Key:  C3B09917-2A25-8D9D-4BD7-0FED69E33CD5
Incident Identifier: 41E8C029-4670-4252-8598-30CB866E9E34

Sleep/Wake UUID:       CB0C3F2B-61BA-4B4F-8B7D-35A41194136B

Time Awake Since Boot: 110000 seconds
Time Since Wake:       1120 seconds

System Integrity Protection: enabled

Triggered by Thread: 9, Dispatch Queue: com.apple.root.user-initiated-qos.cooperative

Exception Type:    EXC_CRASH (SIGABRT)
Exception Codes:   0x0000000000000000, 0x0000000000000000

Termination Reason:  Namespace SIGNAL, Code 6, Abort trap: 6
Terminating Process: keneth_frequency [28377]


Application Specific Information:
abort() called


Last Exception Backtrace:
0   CoreFoundation                	       0x18070abe4 __exceptionPreprocess + 164
1   libobjc.A.dylib               	       0x18019691c objc_exception_throw + 88
2   CoreFoundation                	       0x18070aae0 +[NSException exceptionWithName:reason:userInfo:] + 0
3   AVFAudio                      	       0x225c72fe8 _AVAE_CheckAndReturnErr(char const*, int, char const*, char const*, bool, int, NSError**) + 400
4   AVFAudio                      	       0x225c7ee04 AVAudioEngineGraph::RemoveNode(AVAudioNode*, NSError**) + 888
5   AVFAudio                      	       0x225c8aac8 -[AVAudioNode didDetachFromEngine:error:] + 80
6   AVFAudio                      	       0x225ca27b4 AVAudioEngineImpl::DetachNode(AVAudioNode*, bool, NSError**) + 368
7   AVFAudio                      	       0x225caa74c -[AVAudioEngine detachNode:] + 60
8   keneth_frequency              	       0x100e0e21c specialized CoreAudioSession.playSweepAndRecord(sweepSamples:outputChannel:inputChannel:onRms:) + 144 (CoreAudioSession.swift:193)
9   keneth_frequency              	       0x100e0ad95 closure #2 in AudioChannel.handlePlaySweepAndRecord(call:result:) + 1 (AudioChannel.swift:100)
10  keneth_frequency              	       0x100e0baa5 <deduplicated_symbol> + 1
11  keneth_frequency              	       0x100e0b749 specialized thunk for @escaping @isolated(any) @callee_guaranteed @async () -> (@out A) + 1
12  keneth_frequency              	       0x100e0c165 partial apply for specialized thunk for @escaping @isolated(any) @callee_guaranteed @async () -> (@out A) + 1
13  libswift_Concurrency.dylib    	       0x2846aeec5 completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1

Thread 0::  Dispatch queue: com.apple.main-thread
0   libsystem_kernel.dylib        	       0x18059bc34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1805ae574 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x1805a49c0 mach_msg_overwrite + 480
3   libsystem_kernel.dylib        	       0x18059bfc0 mach_msg + 24
4   CoreFoundation                	       0x18069cd68 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x18069b654 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x18076dbe0 _CFRunLoopRunSpecificWithOptions + 532
7   HIToolbox                     	       0x18d470560 RunCurrentEventLoopInMode + 320
8   HIToolbox                     	       0x18d4738bc ReceiveNextEventCommon + 488
9   HIToolbox                     	       0x18d5fd13c _BlockUntilNextEventMatchingListInMode + 48
10  AppKit                        	       0x1851731a4 _DPSBlockUntilNextEventMatchingListInMode + 228
11  AppKit                        	       0x184ac7084 _DPSNextEvent + 576
12  AppKit                        	       0x18565c69c -[NSApplication(NSEventRouting) _nextEventMatchingEventMask:untilDate:inMode:dequeue:] + 688
13  AppKit                        	       0x18565c3a8 -[NSApplication(NSEventRouting) nextEventMatchingMask:untilDate:inMode:dequeue:] + 72
14  AppKit                        	       0x184aba13c -[NSApplication run] + 368
15  AppKit                        	       0x184a927b0 NSApplicationMain + 880
16  keneth_frequency              	       0x100e09d84 specialized static NSApplicationDelegate.main() + 24 [inlined]
17  keneth_frequency              	       0x100e09d84 static AppDelegate.$main() + 24 (/<compiler-generated>:4) [inlined]
18  keneth_frequency              	       0x100e09d84 main + 36
19  dyld                          	       0x180223da4 start + 6992

Thread 1:: com.apple.NSEventThread
0   libsystem_kernel.dylib        	       0x18059bc34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1805ae574 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x1805a49c0 mach_msg_overwrite + 480
3   libsystem_kernel.dylib        	       0x18059bfc0 mach_msg + 24
4   CoreFoundation                	       0x18069cd68 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x18069b654 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x18076dbe0 _CFRunLoopRunSpecificWithOptions + 532
7   AppKit                        	       0x184be8c64 _NSEventThread + 184
8   libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
9   libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 2:: io.flutter.raster
0   libsystem_kernel.dylib        	       0x18059bc34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1805ae574 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x1805a49c0 mach_msg_overwrite + 480
3   libsystem_kernel.dylib        	       0x18059bfc0 mach_msg + 24
4   CoreFoundation                	       0x18069cd68 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x18069b654 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x18076dbe0 _CFRunLoopRunSpecificWithOptions + 532
7   FlutterMacOS                  	       0x102d25684 fml::MessageLoopDarwin::Run() + 144 (message_loop_darwin.mm:51)
8   FlutterMacOS                  	       0x102d1b9f0 fml::MessageLoopImpl::DoRun() + 100 (message_loop_impl.cc:94)
9   FlutterMacOS                  	       0x102d23cb8 fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0::operator()() const + 164 (thread.cc:154) [inlined]
10  FlutterMacOS                  	       0x102d23cb8 decltype(std::declval<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>()()) std::__fl::__invoke[abi:nn210000]<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&) + 164 (invoke.h:179) [inlined]
11  FlutterMacOS                  	       0x102d23cb8 void std::__fl::__invoke_void_return_wrapper<void, true>::__call[abi:nn210000]<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&) + 164 (invoke.h:251) [inlined]
12  FlutterMacOS                  	       0x102d23cb8 void std::__fl::__invoke_r[abi:nn210000]<void, fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&) + 164 (invoke.h:273) [inlined]
13  FlutterMacOS                  	       0x102d23cb8 std::__fl::__function::__alloc_func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()[abi:nn210000]() + 164 (function.h:167) [inlined]
14  FlutterMacOS                  	       0x102d23cb8 std::__fl::__function::__func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()() + 200 (function.h:319)
15  FlutterMacOS                  	       0x102d23708 std::__fl::__function::__value_func<void ()>::operator()[abi:nn210000]() const + 36 (function.h:436) [inlined]
16  FlutterMacOS                  	       0x102d23708 std::__fl::function<void ()>::operator()() const + 36 (function.h:995) [inlined]
17  FlutterMacOS                  	       0x102d23708 fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::operator()(void*) const + 36 (thread.cc:76) [inlined]
18  FlutterMacOS                  	       0x102d23708 fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::__invoke(void*) + 56 (thread.cc:73)
19  libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
20  libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 3:: io.flutter.io
0   libsystem_kernel.dylib        	       0x18059bc34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1805ae574 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x1805a49c0 mach_msg_overwrite + 480
3   libsystem_kernel.dylib        	       0x18059bfc0 mach_msg + 24
4   CoreFoundation                	       0x18069cd68 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x18069b654 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x18076dbe0 _CFRunLoopRunSpecificWithOptions + 532
7   FlutterMacOS                  	       0x102d25684 fml::MessageLoopDarwin::Run() + 144 (message_loop_darwin.mm:51)
8   FlutterMacOS                  	       0x102d1b9f0 fml::MessageLoopImpl::DoRun() + 100 (message_loop_impl.cc:94)
9   FlutterMacOS                  	       0x102d23cb8 fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0::operator()() const + 164 (thread.cc:154) [inlined]
10  FlutterMacOS                  	       0x102d23cb8 decltype(std::declval<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>()()) std::__fl::__invoke[abi:nn210000]<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&) + 164 (invoke.h:179) [inlined]
11  FlutterMacOS                  	       0x102d23cb8 void std::__fl::__invoke_void_return_wrapper<void, true>::__call[abi:nn210000]<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&) + 164 (invoke.h:251) [inlined]
12  FlutterMacOS                  	       0x102d23cb8 void std::__fl::__invoke_r[abi:nn210000]<void, fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&) + 164 (invoke.h:273) [inlined]
13  FlutterMacOS                  	       0x102d23cb8 std::__fl::__function::__alloc_func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()[abi:nn210000]() + 164 (function.h:167) [inlined]
14  FlutterMacOS                  	       0x102d23cb8 std::__fl::__function::__func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()() + 200 (function.h:319)
15  FlutterMacOS                  	       0x102d23708 std::__fl::__function::__value_func<void ()>::operator()[abi:nn210000]() const + 36 (function.h:436) [inlined]
16  FlutterMacOS                  	       0x102d23708 std::__fl::function<void ()>::operator()() const + 36 (function.h:995) [inlined]
17  FlutterMacOS                  	       0x102d23708 fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::operator()(void*) const + 36 (thread.cc:76) [inlined]
18  FlutterMacOS                  	       0x102d23708 fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::__invoke(void*) + 56 (thread.cc:73)
19  libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
20  libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 4:: io.worker.1
0   libsystem_kernel.dylib        	       0x18059f50c __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x1805e0128 _pthread_cond_wait + 980
2   FlutterMacOS                  	       0x102cd31c4 std::__fl::__libcpp_condvar_wait[abi:nn210000](_opaque_pthread_cond_t*, _opaque_pthread_mutex_t*) + 4 (pthread.h:122) [inlined]
3   FlutterMacOS                  	       0x102cd31c4 std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&) + 44 (condition_variable.cpp:30)
4   FlutterMacOS                  	       0x102d165dc void std::__fl::condition_variable::wait<fml::ConcurrentMessageLoop::WorkerMain()::$_0>(std::__fl::unique_lock<std::__fl::mutex>&, fml::ConcurrentMessageLoop::WorkerMain()::$_0) + 40 (condition_variable.h:147) [inlined]
5   FlutterMacOS                  	       0x102d165dc fml::ConcurrentMessageLoop::WorkerMain() + 140 (concurrent_message_loop.cc:75)
6   FlutterMacOS                  	       0x102d16fa0 fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0::operator()() const + 484 (concurrent_message_loop.cc:20) [inlined]
7   FlutterMacOS                  	       0x102d16fa0 decltype(std::declval<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>()()) std::__fl::__invoke[abi:nn210000]<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0&&) + 484 (invoke.h:179) [inlined]
8   FlutterMacOS                  	       0x102d16fa0 void std::__fl::__thread_execute[abi:nn210000]<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>&, std::__fl::__tuple_indices<...>) + 484 (thread.h:200) [inlined]
9   FlutterMacOS                  	       0x102d16fa0 void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*) + 560 (thread.h:209)
10  libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
11  libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 5:: io.worker.2
0   libsystem_kernel.dylib        	       0x18059f50c __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x1805e0128 _pthread_cond_wait + 980
2   FlutterMacOS                  	       0x102cd31c4 std::__fl::__libcpp_condvar_wait[abi:nn210000](_opaque_pthread_cond_t*, _opaque_pthread_mutex_t*) + 4 (pthread.h:122) [inlined]
3   FlutterMacOS                  	       0x102cd31c4 std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&) + 44 (condition_variable.cpp:30)
4   FlutterMacOS                  	       0x102d165dc void std::__fl::condition_variable::wait<fml::ConcurrentMessageLoop::WorkerMain()::$_0>(std::__fl::unique_lock<std::__fl::mutex>&, fml::ConcurrentMessageLoop::WorkerMain()::$_0) + 40 (condition_variable.h:147) [inlined]
5   FlutterMacOS                  	       0x102d165dc fml::ConcurrentMessageLoop::WorkerMain() + 140 (concurrent_message_loop.cc:75)
6   FlutterMacOS                  	       0x102d16fa0 fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0::operator()() const + 484 (concurrent_message_loop.cc:20) [inlined]
7   FlutterMacOS                  	       0x102d16fa0 decltype(std::declval<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>()()) std::__fl::__invoke[abi:nn210000]<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0&&) + 484 (invoke.h:179) [inlined]
8   FlutterMacOS                  	       0x102d16fa0 void std::__fl::__thread_execute[abi:nn210000]<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>&, std::__fl::__tuple_indices<...>) + 484 (thread.h:200) [inlined]
9   FlutterMacOS                  	       0x102d16fa0 void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*) + 560 (thread.h:209)
10  libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
11  libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 6:: io.worker.3
0   libsystem_kernel.dylib        	       0x18059f50c __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x1805e0128 _pthread_cond_wait + 980
2   FlutterMacOS                  	       0x102cd31c4 std::__fl::__libcpp_condvar_wait[abi:nn210000](_opaque_pthread_cond_t*, _opaque_pthread_mutex_t*) + 4 (pthread.h:122) [inlined]
3   FlutterMacOS                  	       0x102cd31c4 std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&) + 44 (condition_variable.cpp:30)
4   FlutterMacOS                  	       0x102d165dc void std::__fl::condition_variable::wait<fml::ConcurrentMessageLoop::WorkerMain()::$_0>(std::__fl::unique_lock<std::__fl::mutex>&, fml::ConcurrentMessageLoop::WorkerMain()::$_0) + 40 (condition_variable.h:147) [inlined]
5   FlutterMacOS                  	       0x102d165dc fml::ConcurrentMessageLoop::WorkerMain() + 140 (concurrent_message_loop.cc:75)
6   FlutterMacOS                  	       0x102d16fa0 fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0::operator()() const + 484 (concurrent_message_loop.cc:20) [inlined]
7   FlutterMacOS                  	       0x102d16fa0 decltype(std::declval<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>()()) std::__fl::__invoke[abi:nn210000]<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0&&) + 484 (invoke.h:179) [inlined]
8   FlutterMacOS                  	       0x102d16fa0 void std::__fl::__thread_execute[abi:nn210000]<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>&, std::__fl::__tuple_indices<...>) + 484 (thread.h:200) [inlined]
9   FlutterMacOS                  	       0x102d16fa0 void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*) + 560 (thread.h:209)
10  libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
11  libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 7:: io.worker.4
0   libsystem_kernel.dylib        	       0x18059f50c __psynch_cvwait + 8
1   libsystem_pthread.dylib       	       0x1805e0128 _pthread_cond_wait + 980
2   FlutterMacOS                  	       0x102cd31c4 std::__fl::__libcpp_condvar_wait[abi:nn210000](_opaque_pthread_cond_t*, _opaque_pthread_mutex_t*) + 4 (pthread.h:122) [inlined]
3   FlutterMacOS                  	       0x102cd31c4 std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&) + 44 (condition_variable.cpp:30)
4   FlutterMacOS                  	       0x102d165dc void std::__fl::condition_variable::wait<fml::ConcurrentMessageLoop::WorkerMain()::$_0>(std::__fl::unique_lock<std::__fl::mutex>&, fml::ConcurrentMessageLoop::WorkerMain()::$_0) + 40 (condition_variable.h:147) [inlined]
5   FlutterMacOS                  	       0x102d165dc fml::ConcurrentMessageLoop::WorkerMain() + 140 (concurrent_message_loop.cc:75)
6   FlutterMacOS                  	       0x102d16fa0 fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0::operator()() const + 484 (concurrent_message_loop.cc:20) [inlined]
7   FlutterMacOS                  	       0x102d16fa0 decltype(std::declval<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>()()) std::__fl::__invoke[abi:nn210000]<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0&&) + 484 (invoke.h:179) [inlined]
8   FlutterMacOS                  	       0x102d16fa0 void std::__fl::__thread_execute[abi:nn210000]<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>&, std::__fl::__tuple_indices<...>) + 484 (thread.h:200) [inlined]
9   FlutterMacOS                  	       0x102d16fa0 void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*) + 560 (thread.h:209)
10  libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
11  libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 8:: dart:io EventHandler
0   libsystem_kernel.dylib        	       0x1805a1fc4 kevent + 8
1   FlutterMacOS                  	       0x10356db50 dart::bin::EventHandlerImplementation::EventHandlerEntry(unsigned long) + 304 (eventhandler_macos.cc:459)
2   FlutterMacOS                  	       0x103594ebc dart::bin::ThreadStart(void*) + 92 (thread_macos.cc:65)
3   libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
4   libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 9 Crashed::  Dispatch queue: com.apple.root.user-initiated-qos.cooperative
0   libsystem_kernel.dylib        	       0x1805a45e8 __pthread_kill + 8
1   libsystem_pthread.dylib       	       0x1805df8d8 pthread_kill + 296
2   libsystem_c.dylib             	       0x1804e6790 abort + 148
3   libc++abi.dylib               	       0x18059672c __abort_message + 132
4   libc++abi.dylib               	       0x180583588 demangling_terminate_handler() + 296
5   libobjc.A.dylib               	       0x1801a0894 _objc_terminate() + 156
6   libc++abi.dylib               	       0x18059375c std::__terminate(void (*)()) + 16
7   libc++abi.dylib               	       0x180595be4 __cxxabiv1::failed_throw(__cxxabiv1::__cxa_exception*) + 88
8   libc++abi.dylib               	       0x18058209c __cxa_throw + 92
9   libobjc.A.dylib               	       0x180196a84 objc_exception_throw + 448
10  CoreFoundation                	       0x18070aae0 +[NSException raise:format:] + 128
11  AVFAudio                      	       0x225c72fe8 _AVAE_CheckAndReturnErr(char const*, int, char const*, char const*, bool, int, NSError**) + 400
12  AVFAudio                      	       0x225c7ee04 AVAudioEngineGraph::RemoveNode(AVAudioNode*, NSError**) + 888
13  AVFAudio                      	       0x225c8aac8 -[AVAudioNode didDetachFromEngine:error:] + 80
14  AVFAudio                      	       0x225ca27b4 AVAudioEngineImpl::DetachNode(AVAudioNode*, bool, NSError**) + 368
15  AVFAudio                      	       0x225caa74c -[AVAudioEngine detachNode:] + 60
16  keneth_frequency              	       0x100e0e21c specialized CoreAudioSession.playSweepAndRecord(sweepSamples:outputChannel:inputChannel:onRms:) + 144 (CoreAudioSession.swift:191)
17  keneth_frequency              	       0x100e0ad95 closure #2 in AudioChannel.handlePlaySweepAndRecord(call:result:) + 1 (AudioChannel.swift:100)
18  keneth_frequency              	       0x100e0baa5 <deduplicated_symbol> + 1
19  keneth_frequency              	       0x100e0b749 specialized thunk for @escaping @isolated(any) @callee_guaranteed @async () -> (@out A) + 1
20  keneth_frequency              	       0x100e0c165 partial apply for specialized thunk for @escaping @isolated(any) @callee_guaranteed @async () -> (@out A) + 1
21  libswift_Concurrency.dylib    	       0x2846aeec5 completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1

Thread 10:

Thread 11:: caulk.messenger.shared:17
0   libsystem_kernel.dylib        	       0x18059bbb0 semaphore_wait_trap + 8
1   caulk                         	       0x18cf18e00 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x18cf18cac caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x18cf1894c void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 12:: caulk.messenger.shared:high
0   libsystem_kernel.dylib        	       0x18059bbb0 semaphore_wait_trap + 8
1   caulk                         	       0x18cf18e00 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x18cf18cac caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x18cf1894c void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 13:: com.apple.audio.toolbox.AUScheduledParameterRefresher
0   libsystem_kernel.dylib        	       0x18059bbb0 semaphore_wait_trap + 8
1   caulk                         	       0x18cf18e00 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x18cf18cac caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x18cf1894c void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 14:: caulk::deferred_logger
0   libsystem_kernel.dylib        	       0x18059bbb0 semaphore_wait_trap + 8
1   caulk                         	       0x18cf18e00 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x18cf18cac caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x18cf1894c void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 15:: com.apple.audio.IOThread.client
0   libsystem_kernel.dylib        	       0x18059bbbc semaphore_wait_signal_trap + 8
1   caulk                         	       0x18cf36290 caulk::mach::semaphore::wait_signal_or_error(caulk::mach::semaphore&) + 36
2   CoreAudio                     	       0x18392ba44 HALC_ProxyIOContext::IOWorkLoop() + 4952
3   CoreAudio                     	       0x18392a050 invocation function for block in HALC_ProxyIOContext::HALC_ProxyIOContext(unsigned int, unsigned int) + 172
4   CoreAudio                     	       0x183ae80b0 HALC_IOThread::Entry(void*) + 88
5   libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
6   libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8

Thread 16:

Thread 17:: HIE: __ 3b7cb4d234b66b58 2026-04-19 18:23:19.247
0   libsystem_kernel.dylib        	       0x18059bc34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1805ae574 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x1805cc0f0 thread_suspend + 108
3   HIServices                    	       0x187caa3e0 SOME_OTHER_THREAD_SWALLOWED_AT_LEAST_ONE_EXCEPTION + 20
4   Foundation                    	       0x181edea90 __NSThread__start__ + 732
5   libsystem_pthread.dylib       	       0x1805dfc58 _pthread_start + 136
6   libsystem_pthread.dylib       	       0x1805dac1c thread_start + 8


Thread 9 crashed with ARM Thread State (64-bit):
    x0: 0x0000000000000000   x1: 0x0000000000000000   x2: 0x0000000000000000   x3: 0x0000000000000000
    x4: 0x0000000180596d97   x5: 0x000000016fc259a0   x6: 0x000000000000006e   x7: 0xfffff0003ffff800
    x8: 0x6f5ddff10fd4e20a   x9: 0x6f5ddff06016920a  x10: 0x0000000000000002  x11: 0x00000000fffffffd
   x12: 0x0000000000000000  x13: 0x0000000000000000  x14: 0x0000000000000000  x15: 0x0000000000000000
   x16: 0x0000000000000148  x17: 0x00000001eda21f20  x18: 0x0000000000000000  x19: 0x0000000000000006
   x20: 0x0000000000014d83  x21: 0x000000016fc270e0  x22: 0x00000001e9948000  x23: 0x00000000000006f6
   x24: 0x0000000ac8952940  x25: 0x0000000225cd014f  x26: 0x0000000ac9e41620  x27: 0x0000000ac8719590
   x28: 0x0000000ac9c6b980   fp: 0x000000016fc25910   lr: 0x00000001805df8d8
    sp: 0x000000016fc258f0   pc: 0x00000001805a45e8 cpsr: 0x40000000
   far: 0x0000000000000000  esr: 0x56000080 (Syscall)

Binary Images:
       0x100e08000 -        0x100e13fff com.example.kenethFrequency (1.0.0) <c33c4478-8ca2-3888-9615-e3bb059b53f8> /Users/USER/Documents/*/keneth_frequency.app/Contents/MacOS/keneth_frequency
       0x100e80000 -        0x100e87fff org.cocoapods.share-plus (0.0.1) <d6edd5af-3339-36f1-8519-e443253a051b> /Users/USER/Documents/*/keneth_frequency.app/Contents/Frameworks/share_plus.framework/Versions/A/share_plus
       0x100e38000 -        0x100e47fff org.cocoapods.shared-preferences-foundation (0.0.1) <ca8d4221-265e-3e96-880c-c33957897862> /Users/USER/Documents/*/keneth_frequency.app/Contents/Frameworks/shared_preferences_foundation.framework/Versions/A/shared_preferences_foundation
       0x100ea4000 -        0x100f8bfff org.cocoapods.sqlite3 (3.52.0) <c749cda5-6df3-3208-bea8-247b044c9bb9> /Users/USER/Documents/*/keneth_frequency.app/Contents/Frameworks/sqlite3.framework/Versions/A/sqlite3
       0x101010000 -        0x101013fff org.cocoapods.sqlite3-flutter-libs (0.0.1) <4d3a3695-77f6-3fa1-abf9-34408ca00bd9> /Users/USER/Documents/*/keneth_frequency.app/Contents/Frameworks/sqlite3_flutter_libs.framework/Versions/A/sqlite3_flutter_libs
       0x102c8c000 -        0x103947fff io.flutter.flutter-macos (1.0) <4c4c44fc-5555-3144-a173-27fbbe0f0376> /Users/USER/Documents/*/keneth_frequency.app/Contents/Frameworks/FlutterMacOS.framework/Versions/A/FlutterMacOS
       0x1026d4000 -        0x1026dffff libobjc-trampolines.dylib (*) <a4dd56f1-375a-3540-844b-5e397f0b78b3> /usr/lib/libobjc-trampolines.dylib
       0x1160f8000 -        0x11676ffff io.flutter.flutter.app (1.0) <efc96520-7504-3c37-8068-4966f7369c25> /Users/USER/Documents/*/keneth_frequency.app/Contents/Frameworks/App.framework/Versions/A/App
       0x1182a0000 -        0x118c57fff com.apple.AGXMetalG17G (350.38) <c44193ee-a732-3f50-acb5-a6d3a6ca2a27> /System/Library/Extensions/AGXMetalG17G.bundle/Contents/MacOS/AGXMetalG17G
       0x11695c000 -        0x11696ffff io.flutter.flutter.native-assets.objective-c (1.0) <cc8396a6-de66-3b41-8a7e-b9de4b42d04b> /Users/USER/Documents/*/keneth_frequency.app/Contents/Frameworks/objective_c.framework/Versions/A/objective_c
       0x102380000 -        0x1024bbfff com.apple.audio.units.Components (1.14) <dd44ad41-2925-3a96-ae04-9a68575a3549> /System/Library/Components/CoreAudio.component/Contents/MacOS/CoreAudio
       0x18059b000 -        0x1805d828f libsystem_kernel.dylib (*) <51565b39-f595-3e96-a217-fef29815057a> /usr/lib/system/libsystem_kernel.dylib
       0x18061f000 -        0x180b7cc5f com.apple.CoreFoundation (6.9) <04941709-2330-3bf8-9213-6d33964db448> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x18d3b3000 -        0x18d6ae05f com.apple.HIToolbox (2.1.1) <bcb81496-c81f-3d3e-a617-ccca047989e0> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/HIToolbox
       0x184a8e000 -        0x1861b0abf com.apple.AppKit (6.9) <59e23bd5-d01e-305a-b96f-a5790356049a> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x180204000 -        0x1802a9ec7 dyld (*) <9f682dcf-340c-3bfa-bcdd-dd702f30313e> /usr/lib/dyld
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x1805d9000 -        0x1805e5b3b libsystem_pthread.dylib (*) <e7a73008-0c09-31e3-9dd9-0c61652f0e85> /usr/lib/system/libsystem_pthread.dylib
       0x18046e000 -        0x1804eeef7 libsystem_c.dylib (*) <66ebd321-6899-3863-ba24-5cfc3076a0cb> /usr/lib/system/libsystem_c.dylib
       0x180580000 -        0x18059a75f libc++abi.dylib (*) <e8d325ed-3b97-325e-b494-b1b0ff93d133> /usr/lib/libc++abi.dylib
       0x18017c000 -        0x1801ceb4b libobjc.A.dylib (*) <2e858e25-1ff6-3da6-84f6-911630620512> /usr/lib/libobjc.A.dylib
       0x225bbd000 -        0x225cff9ff com.apple.audio.AVFAudio (1.0) <8e4d44ee-1b59-3dc5-bac8-fd96078883d4> /System/Library/Frameworks/AVFAudio.framework/Versions/A/AVFAudio
       0x2846a2000 -        0x28472d095 libswift_Concurrency.dylib (*) <02634765-cb69-3c2b-9cce-10103cbea22a> /usr/lib/swift/libswift_Concurrency.dylib
       0x18cf17000 -        0x18cf4003f com.apple.audio.caulk (1.0) <2bdd6811-ce34-3098-9833-10d9f74b7ffc> /System/Library/PrivateFrameworks/caulk.framework/Versions/A/caulk
       0x18372a000 -        0x183ebfe9f com.apple.audio.CoreAudio (5.0) <72080a9b-8c5b-3e6d-8de7-0f86c3e698ec> /System/Library/Frameworks/CoreAudio.framework/Versions/A/CoreAudio
       0x187c74000 -        0x187cdf35f com.apple.HIServices (1.22) <3aa36b9f-7d37-35ff-8034-a16dabfe5981> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/HIServices.framework/Versions/A/HIServices
       0x181e8b000 -        0x182e6d1df com.apple.Foundation (6.9) <8e9a5c62-7e95-3047-81e7-735ae1aee5f8> /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0

VM Region Summary:
ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)
Writable regions: Total=209.1M written=689K(0%) resident=689K(0%) swapped_out=0K(0%) unallocated=208.4M(100%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Accelerate framework               128K        1 
Activity Tracing                   256K        1 
AttributeGraph Data               1024K        1 
ColorSync                           16K        1 
CoreAnimation                      656K       29 
CoreGraphics                        32K        2 
CoreUI image data                  400K        3 
Foundation                          48K        2 
Kernel Alloc Once                   32K        1 
MALLOC                            93.8M       30 
MALLOC guard page                 4016K        4 
Memory Tag 22                     64.0M        1 
STACK GUARD                       56.3M       18 
Stack                             20.6M       20 
VM_ALLOCATE                       25.3M       42 
VM_ALLOCATE (reserved)             768K        1         reserved VM address space (unallocated)
__AUTH                            5945K      625 
__AUTH_CONST                      88.5M     1011 
__CTF                               824        1 
__DATA                            34.4M      969 
__DATA_CONST                      34.9M     1025 
__DATA_DIRTY                      8304K      868 
__FONT_DATA                        2352        1 
__LINKEDIT                       576.2M       12 
__OBJC_RO                         79.1M        1 
__OBJC_RW                         2597K        1 
__TEXT                             1.2G     1050 
__TPRO_CONST                       128K        2 
mapped file                      295.4M       40 
page table in kernel               689K        1 
shared memory                     3744K       17 
===========                     =======  ======= 
TOTAL                              2.6G     5781 
TOTAL, minus reserved VM space     2.6G     5781 


-----------
Full Report
-----------

{"app_name":"keneth_frequency","timestamp":"2026-04-19 18:23:26.00 -0400","app_version":"1.0.0","slice_uuid":"c33c4478-8ca2-3888-9615-e3bb059b53f8","build_version":"1","platform":1,"bundleID":"com.example.kenethFrequency","share_with_app_devs":1,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.4.1 (25E253)","roots_installed":0,"name":"keneth_frequency","incident_id":"41E8C029-4670-4252-8598-30CB866E9E34"}
{
  "uptime" : 110000,
  "procRole" : "Foreground",
  "version" : 2,
  "userID" : 501,
  "deployVersion" : 210,
  "modelCode" : "Mac17,4",
  "coalitionID" : 10176,
  "osVersion" : {
    "train" : "macOS 26.4.1",
    "build" : "25E253",
    "releaseType" : "User"
  },
  "captureTime" : "2026-04-19 18:23:19.2651 -0400",
  "codeSigningMonitor" : 2,
  "incident" : "41E8C029-4670-4252-8598-30CB866E9E34",
  "pid" : 28377,
  "translated" : false,
  "cpuType" : "ARM-64",
  "procLaunch" : "2026-04-19 18:22:17.2746 -0400",
  "procStartAbsTime" : 2732912509805,
  "procExitAbsTime" : 2734400008349,
  "procName" : "keneth_frequency",
  "procPath" : "\/Users\/USER\/Documents\/*\/keneth_frequency.app\/Contents\/MacOS\/keneth_frequency",
  "bundleInfo" : {"CFBundleShortVersionString":"1.0.0","CFBundleVersion":"1","CFBundleIdentifier":"com.example.kenethFrequency"},
  "storeInfo" : {"deviceIdentifierForVendor":"1C5063BE-7C5A-5685-A7BD-3919374F7B33","thirdParty":true},
  "parentProc" : "launchd",
  "parentPid" : 1,
  "coalitionName" : "com.example.kenethFrequency",
  "crashReporterKey" : "C3B09917-2A25-8D9D-4BD7-0FED69E33CD5",
  "appleIntelligenceStatus" : {"state":"available"},
  "developerMode" : 1,
  "codeSigningID" : "com.example.kenethFrequency",
  "codeSigningTeamID" : "",
  "codeSigningFlags" : 570425861,
  "codeSigningValidationCategory" : 10,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"fyMD1f17v6n9AwCRCuD\/l78DAJH9e8Go\/w9f1sADX9YQKYDSARAA1A==","atPC":"AwEAVH8jA9X9e7+p\/QMAkf\/f\/5e\/AwCR\/XvBqP8PX9bAA1\/WcAqA0g=="},
  "bootSessionUUID" : "918722CC-1F6F-459C-B00A-BBA8C177C288",
  "wakeTime" : 1120,
  "sleepWakeUUID" : "CB0C3F2B-61BA-4B4F-8B7D-35A41194136B",
  "sip" : "enabled",
  "exception" : {"codes":"0x0000000000000000, 0x0000000000000000","rawCodes":[0,0],"type":"EXC_CRASH","signal":"SIGABRT"},
  "termination" : {"flags":0,"code":6,"namespace":"SIGNAL","indicator":"Abort trap: 6","byProc":"keneth_frequency","byPid":28377},
  "asi" : {"libsystem_c.dylib":["abort() called"]},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "lastExceptionBacktrace" : [{"imageOffset":965604,"symbol":"__exceptionPreprocess","symbolLocation":164,"imageIndex":12},{"imageOffset":108828,"symbol":"objc_exception_throw","symbolLocation":88,"imageIndex":20},{"imageOffset":965344,"symbol":"+[NSException exceptionWithName:reason:userInfo:]","symbolLocation":0,"imageIndex":12},{"imageOffset":745448,"symbol":"_AVAE_CheckAndReturnErr(char const*, int, char const*, char const*, bool, int, NSError**)","symbolLocation":400,"imageIndex":21},{"imageOffset":794116,"symbol":"AVAudioEngineGraph::RemoveNode(AVAudioNode*, NSError**)","symbolLocation":888,"imageIndex":21},{"imageOffset":842440,"symbol":"-[AVAudioNode didDetachFromEngine:error:]","symbolLocation":80,"imageIndex":21},{"imageOffset":939956,"symbol":"AVAudioEngineImpl::DetachNode(AVAudioNode*, bool, NSError**)","symbolLocation":368,"imageIndex":21},{"imageOffset":972620,"symbol":"-[AVAudioEngine detachNode:]","symbolLocation":60,"imageIndex":21},{"imageOffset":25116,"sourceLine":193,"sourceFile":"CoreAudioSession.swift","symbol":"specialized CoreAudioSession.playSweepAndRecord(sweepSamples:outputChannel:inputChannel:onRms:)","imageIndex":0,"symbolLocation":144},{"imageOffset":11669,"sourceLine":100,"sourceFile":"AudioChannel.swift","symbol":"closure #2 in AudioChannel.handlePlaySweepAndRecord(call:result:)","imageIndex":0,"symbolLocation":1},{"imageOffset":15013,"symbol":"<deduplicated_symbol>","symbolLocation":1,"imageIndex":0},{"imageOffset":14153,"sourceFile":"\/<compiler-generated>","symbol":"specialized thunk for @escaping @isolated(any) @callee_guaranteed @async () -> (@out A)","symbolLocation":1,"imageIndex":0},{"imageOffset":16741,"symbol":"partial apply for specialized thunk for @escaping @isolated(any) @callee_guaranteed @async () -> (@out A)","symbolLocation":1,"imageIndex":0},{"imageOffset":52933,"symbol":"completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*)","symbolLocation":1,"imageIndex":22}],
  "faultingThread" : 9,
  "threads" : [{"id":2765594,"threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":42893838385152},{"value":0},{"value":42893838385152},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":9987},{"value":57174604657664},{"value":18446744073709551569},{"value":8281794096},{"value":0},{"value":4294967295},{"value":2},{"value":42893838385152},{"value":0},{"value":42893838385152},{"value":21592279046},{"value":6157196760},{"value":8589934592},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6448407924},"cpsr":{"value":0},"fp":{"value":6157196608},"sp":{"value":6157196528},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448331828},"far":{"value":0}},"queue":"com.apple.main-thread","frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":79220,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":11},{"imageOffset":39360,"symbol":"mach_msg_overwrite","symbolLocation":480,"imageIndex":11},{"imageOffset":4032,"symbol":"mach_msg","symbolLocation":24,"imageIndex":11},{"imageOffset":515432,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":12},{"imageOffset":509524,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":12},{"imageOffset":1371104,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":12},{"imageOffset":775520,"symbol":"RunCurrentEventLoopInMode","symbolLocation":320,"imageIndex":13},{"imageOffset":788668,"symbol":"ReceiveNextEventCommon","symbolLocation":488,"imageIndex":13},{"imageOffset":2400572,"symbol":"_BlockUntilNextEventMatchingListInMode","symbolLocation":48,"imageIndex":13},{"imageOffset":7229860,"symbol":"_DPSBlockUntilNextEventMatchingListInMode","symbolLocation":228,"imageIndex":14},{"imageOffset":233604,"symbol":"_DPSNextEvent","symbolLocation":576,"imageIndex":14},{"imageOffset":12379804,"symbol":"-[NSApplication(NSEventRouting) _nextEventMatchingEventMask:untilDate:inMode:dequeue:]","symbolLocation":688,"imageIndex":14},{"imageOffset":12379048,"symbol":"-[NSApplication(NSEventRouting) nextEventMatchingMask:untilDate:inMode:dequeue:]","symbolLocation":72,"imageIndex":14},{"imageOffset":180540,"symbol":"-[NSApplication run]","symbolLocation":368,"imageIndex":14},{"imageOffset":18352,"symbol":"NSApplicationMain","symbolLocation":880,"imageIndex":14},{"imageOffset":7556,"sourceFile":"AppDelegate.swift","symbol":"specialized static NSApplicationDelegate.main()","imageIndex":0,"symbolLocation":24,"inline":true},{"symbol":"static AppDelegate.$main()","inline":true,"imageIndex":0,"imageOffset":7556,"symbolLocation":24,"sourceLine":4,"sourceFile":"\/<compiler-generated>"},{"imageOffset":7556,"sourceFile":"AppDelegate.swift","symbol":"main","symbolLocation":36,"imageIndex":0},{"imageOffset":130468,"symbol":"start","symbolLocation":6992,"imageIndex":15}]},{"id":2765614,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":134153303490560},{"value":0},{"value":134153303490560},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":31235},{"value":0},{"value":18446744073709551569},{"value":8281794096},{"value":0},{"value":4294967295},{"value":2},{"value":134153303490560},{"value":0},{"value":134153303490560},{"value":21592279046},{"value":6160048264},{"value":8589934592},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6448407924},"cpsr":{"value":0},"fp":{"value":6160048112},"sp":{"value":6160048032},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448331828},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":79220,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":11},{"imageOffset":39360,"symbol":"mach_msg_overwrite","symbolLocation":480,"imageIndex":11},{"imageOffset":4032,"symbol":"mach_msg","symbolLocation":24,"imageIndex":11},{"imageOffset":515432,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":12},{"imageOffset":509524,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":12},{"imageOffset":1371104,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":12},{"imageOffset":1420388,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":14},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2765620,"name":"io.flutter.raster","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":271592256962560},{"value":0},{"value":271592256962560},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":63235},{"value":0},{"value":18446744073709551569},{"value":8281794096},{"value":0},{"value":4294967295},{"value":2},{"value":271592256962560},{"value":0},{"value":271592256962560},{"value":21592279046},{"value":6162767832},{"value":8589934592},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6448407924},"cpsr":{"value":0},"fp":{"value":6162767680},"sp":{"value":6162767600},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448331828},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":79220,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":11},{"imageOffset":39360,"symbol":"mach_msg_overwrite","symbolLocation":480,"imageIndex":11},{"imageOffset":4032,"symbol":"mach_msg","symbolLocation":24,"imageIndex":11},{"imageOffset":515432,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":12},{"imageOffset":509524,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":12},{"imageOffset":1371104,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":12},{"imageOffset":628356,"sourceLine":51,"sourceFile":"message_loop_darwin.mm","symbol":"fml::MessageLoopDarwin::Run()","imageIndex":5,"symbolLocation":144},{"imageOffset":588272,"sourceLine":94,"sourceFile":"message_loop_impl.cc","symbol":"fml::MessageLoopImpl::DoRun()","imageIndex":5,"symbolLocation":100},{"symbol":"fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0::operator()() const","inline":true,"imageIndex":5,"imageOffset":621752,"symbolLocation":164,"sourceLine":154,"sourceFile":"thread.cc"},{"symbol":"decltype(std::declval<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>()()) std::__fl::__invoke[abi:nn210000]<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&)","inline":true,"imageIndex":5,"imageOffset":621752,"symbolLocation":164,"sourceLine":179,"sourceFile":"invoke.h"},{"symbol":"void std::__fl::__invoke_void_return_wrapper<void, true>::__call[abi:nn210000]<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&)","inline":true,"imageIndex":5,"imageOffset":621752,"symbolLocation":164,"sourceLine":251,"sourceFile":"invoke.h"},{"symbol":"void std::__fl::__invoke_r[abi:nn210000]<void, fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&)","inline":true,"imageIndex":5,"imageOffset":621752,"symbolLocation":164,"sourceLine":273,"sourceFile":"invoke.h"},{"symbol":"std::__fl::__function::__alloc_func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()[abi:nn210000]()","inline":true,"imageIndex":5,"imageOffset":621752,"symbolLocation":164,"sourceLine":167,"sourceFile":"function.h"},{"imageOffset":621752,"sourceLine":319,"sourceFile":"function.h","symbol":"std::__fl::__function::__func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()()","imageIndex":5,"symbolLocation":200},{"symbol":"std::__fl::__function::__value_func<void ()>::operator()[abi:nn210000]() const","inline":true,"imageIndex":5,"imageOffset":620296,"symbolLocation":36,"sourceLine":436,"sourceFile":"function.h"},{"symbol":"std::__fl::function<void ()>::operator()() const","inline":true,"imageIndex":5,"imageOffset":620296,"symbolLocation":36,"sourceLine":995,"sourceFile":"function.h"},{"symbol":"fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::operator()(void*) const","inline":true,"imageIndex":5,"imageOffset":620296,"symbolLocation":36,"sourceLine":76,"sourceFile":"thread.cc"},{"imageOffset":620296,"sourceLine":73,"sourceFile":"thread.cc","symbol":"fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::__invoke(void*)","imageIndex":5,"symbolLocation":56},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2765621,"name":"io.flutter.io","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":200124001157120},{"value":0},{"value":200124001157120},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":46595},{"value":0},{"value":18446744073709551569},{"value":8281794096},{"value":0},{"value":4294967295},{"value":2},{"value":200124001157120},{"value":0},{"value":200124001157120},{"value":21592279046},{"value":6164914136},{"value":8589934592},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6448407924},"cpsr":{"value":0},"fp":{"value":6164913984},"sp":{"value":6164913904},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448331828},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":79220,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":11},{"imageOffset":39360,"symbol":"mach_msg_overwrite","symbolLocation":480,"imageIndex":11},{"imageOffset":4032,"symbol":"mach_msg","symbolLocation":24,"imageIndex":11},{"imageOffset":515432,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":12},{"imageOffset":509524,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":12},{"imageOffset":1371104,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":12},{"imageOffset":628356,"sourceLine":51,"sourceFile":"message_loop_darwin.mm","symbol":"fml::MessageLoopDarwin::Run()","imageIndex":5,"symbolLocation":144},{"imageOffset":588272,"sourceLine":94,"sourceFile":"message_loop_impl.cc","symbol":"fml::MessageLoopImpl::DoRun()","imageIndex":5,"symbolLocation":100},{"symbol":"fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0::operator()() const","inline":true,"imageIndex":5,"imageOffset":621752,"symbolLocation":164,"sourceLine":154,"sourceFile":"thread.cc"},{"symbol":"decltype(std::declval<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>()()) std::__fl::__invoke[abi:nn210000]<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&)","inline":true,"imageIndex":5,"imageOffset":621752,"symbolLocation":164,"sourceLine":179,"sourceFile":"invoke.h"},{"symbol":"void std::__fl::__invoke_void_return_wrapper<void, true>::__call[abi:nn210000]<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&)","inline":true,"imageIndex":5,"imageOffset":621752,"symbolLocation":164,"sourceLine":251,"sourceFile":"invoke.h"},{"symbol":"void std::__fl::__invoke_r[abi:nn210000]<void, fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&>(fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0&)","inline":true,"imageIndex":5,"imageOffset":621752,"symbolLocation":164,"sourceLine":273,"sourceFile":"invoke.h"},{"symbol":"std::__fl::__function::__alloc_func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()[abi:nn210000]()","inline":true,"imageIndex":5,"imageOffset":621752,"symbolLocation":164,"sourceLine":167,"sourceFile":"function.h"},{"imageOffset":621752,"sourceLine":319,"sourceFile":"function.h","symbol":"std::__fl::__function::__func<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0, std::__fl::allocator<fml::Thread::Thread(std::__fl::function<void (fml::Thread::ThreadConfig const&)> const&, fml::Thread::ThreadConfig const&)::$_0>, void ()>::operator()()","imageIndex":5,"symbolLocation":200},{"symbol":"std::__fl::__function::__value_func<void ()>::operator()[abi:nn210000]() const","inline":true,"imageIndex":5,"imageOffset":620296,"symbolLocation":36,"sourceLine":436,"sourceFile":"function.h"},{"symbol":"std::__fl::function<void ()>::operator()() const","inline":true,"imageIndex":5,"imageOffset":620296,"symbolLocation":36,"sourceLine":995,"sourceFile":"function.h"},{"symbol":"fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::operator()(void*) const","inline":true,"imageIndex":5,"imageOffset":620296,"symbolLocation":36,"sourceLine":76,"sourceFile":"thread.cc"},{"imageOffset":620296,"sourceLine":73,"sourceFile":"thread.cc","symbol":"fml::ThreadHandle::ThreadHandle(std::__fl::function<void ()>&&)::$_0::__invoke(void*)","imageIndex":5,"symbolLocation":56},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2765622,"name":"io.worker.1","threadState":{"x":[{"value":4},{"value":0},{"value":1024},{"value":0},{"value":0},{"value":160},{"value":0},{"value":0},{"value":6165491160},{"value":0},{"value":256},{"value":1099511628034},{"value":1099511628034},{"value":256},{"value":0},{"value":1099511628032},{"value":305},{"value":8281792216},{"value":0},{"value":46326380664},{"value":46326380728},{"value":6165491936},{"value":0},{"value":0},{"value":1024},{"value":1025},{"value":1280},{"value":46329902016},{"value":8}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6448611624},"cpsr":{"value":1610612736},"fp":{"value":6165491280},"sp":{"value":6165491136},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448346380},"far":{"value":0}},"frames":[{"imageOffset":17676,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":11},{"imageOffset":28968,"symbol":"_pthread_cond_wait","symbolLocation":980,"imageIndex":17},{"symbol":"std::__fl::__libcpp_condvar_wait[abi:nn210000](_opaque_pthread_cond_t*, _opaque_pthread_mutex_t*)","inline":true,"imageIndex":5,"imageOffset":291268,"symbolLocation":4,"sourceLine":122,"sourceFile":"pthread.h"},{"imageOffset":291268,"sourceLine":30,"sourceFile":"condition_variable.cpp","symbol":"std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&)","imageIndex":5,"symbolLocation":44},{"symbol":"void std::__fl::condition_variable::wait<fml::ConcurrentMessageLoop::WorkerMain()::$_0>(std::__fl::unique_lock<std::__fl::mutex>&, fml::ConcurrentMessageLoop::WorkerMain()::$_0)","inline":true,"imageIndex":5,"imageOffset":566748,"symbolLocation":40,"sourceLine":147,"sourceFile":"condition_variable.h"},{"imageOffset":566748,"sourceLine":75,"sourceFile":"concurrent_message_loop.cc","symbol":"fml::ConcurrentMessageLoop::WorkerMain()","imageIndex":5,"symbolLocation":140},{"symbol":"fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0::operator()() const","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":20,"sourceFile":"concurrent_message_loop.cc"},{"symbol":"decltype(std::declval<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>()()) std::__fl::__invoke[abi:nn210000]<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0&&)","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":179,"sourceFile":"invoke.h"},{"symbol":"void std::__fl::__thread_execute[abi:nn210000]<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>&, std::__fl::__tuple_indices<...>)","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":200,"sourceFile":"thread.h"},{"imageOffset":569248,"sourceLine":209,"sourceFile":"thread.h","symbol":"void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*)","imageIndex":5,"symbolLocation":560},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2765623,"name":"io.worker.2","threadState":{"x":[{"value":4},{"value":0},{"value":1024},{"value":0},{"value":0},{"value":160},{"value":0},{"value":0},{"value":6166064600},{"value":0},{"value":256},{"value":1099511628034},{"value":1099511628034},{"value":256},{"value":0},{"value":1099511628032},{"value":305},{"value":8281792216},{"value":0},{"value":46326380664},{"value":46326380728},{"value":6166065376},{"value":0},{"value":0},{"value":1024},{"value":1024},{"value":1792},{"value":46329902048},{"value":8}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6448611624},"cpsr":{"value":1610612736},"fp":{"value":6166064720},"sp":{"value":6166064576},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448346380},"far":{"value":0}},"frames":[{"imageOffset":17676,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":11},{"imageOffset":28968,"symbol":"_pthread_cond_wait","symbolLocation":980,"imageIndex":17},{"symbol":"std::__fl::__libcpp_condvar_wait[abi:nn210000](_opaque_pthread_cond_t*, _opaque_pthread_mutex_t*)","inline":true,"imageIndex":5,"imageOffset":291268,"symbolLocation":4,"sourceLine":122,"sourceFile":"pthread.h"},{"imageOffset":291268,"sourceLine":30,"sourceFile":"condition_variable.cpp","symbol":"std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&)","imageIndex":5,"symbolLocation":44},{"symbol":"void std::__fl::condition_variable::wait<fml::ConcurrentMessageLoop::WorkerMain()::$_0>(std::__fl::unique_lock<std::__fl::mutex>&, fml::ConcurrentMessageLoop::WorkerMain()::$_0)","inline":true,"imageIndex":5,"imageOffset":566748,"symbolLocation":40,"sourceLine":147,"sourceFile":"condition_variable.h"},{"imageOffset":566748,"sourceLine":75,"sourceFile":"concurrent_message_loop.cc","symbol":"fml::ConcurrentMessageLoop::WorkerMain()","imageIndex":5,"symbolLocation":140},{"symbol":"fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0::operator()() const","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":20,"sourceFile":"concurrent_message_loop.cc"},{"symbol":"decltype(std::declval<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>()()) std::__fl::__invoke[abi:nn210000]<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0&&)","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":179,"sourceFile":"invoke.h"},{"symbol":"void std::__fl::__thread_execute[abi:nn210000]<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>&, std::__fl::__tuple_indices<...>)","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":200,"sourceFile":"thread.h"},{"imageOffset":569248,"sourceLine":209,"sourceFile":"thread.h","symbol":"void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*)","imageIndex":5,"symbolLocation":560},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2765624,"name":"io.worker.3","threadState":{"x":[{"value":4},{"value":0},{"value":1024},{"value":0},{"value":0},{"value":160},{"value":0},{"value":0},{"value":6166638040},{"value":0},{"value":256},{"value":1099511628034},{"value":1099511628034},{"value":256},{"value":0},{"value":1099511628032},{"value":305},{"value":8281792216},{"value":0},{"value":46326380664},{"value":46326380728},{"value":6166638816},{"value":0},{"value":0},{"value":1024},{"value":1024},{"value":1536},{"value":46329902080},{"value":8}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6448611624},"cpsr":{"value":1610612736},"fp":{"value":6166638160},"sp":{"value":6166638016},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448346380},"far":{"value":0}},"frames":[{"imageOffset":17676,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":11},{"imageOffset":28968,"symbol":"_pthread_cond_wait","symbolLocation":980,"imageIndex":17},{"symbol":"std::__fl::__libcpp_condvar_wait[abi:nn210000](_opaque_pthread_cond_t*, _opaque_pthread_mutex_t*)","inline":true,"imageIndex":5,"imageOffset":291268,"symbolLocation":4,"sourceLine":122,"sourceFile":"pthread.h"},{"imageOffset":291268,"sourceLine":30,"sourceFile":"condition_variable.cpp","symbol":"std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&)","imageIndex":5,"symbolLocation":44},{"symbol":"void std::__fl::condition_variable::wait<fml::ConcurrentMessageLoop::WorkerMain()::$_0>(std::__fl::unique_lock<std::__fl::mutex>&, fml::ConcurrentMessageLoop::WorkerMain()::$_0)","inline":true,"imageIndex":5,"imageOffset":566748,"symbolLocation":40,"sourceLine":147,"sourceFile":"condition_variable.h"},{"imageOffset":566748,"sourceLine":75,"sourceFile":"concurrent_message_loop.cc","symbol":"fml::ConcurrentMessageLoop::WorkerMain()","imageIndex":5,"symbolLocation":140},{"symbol":"fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0::operator()() const","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":20,"sourceFile":"concurrent_message_loop.cc"},{"symbol":"decltype(std::declval<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>()()) std::__fl::__invoke[abi:nn210000]<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0&&)","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":179,"sourceFile":"invoke.h"},{"symbol":"void std::__fl::__thread_execute[abi:nn210000]<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>&, std::__fl::__tuple_indices<...>)","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":200,"sourceFile":"thread.h"},{"imageOffset":569248,"sourceLine":209,"sourceFile":"thread.h","symbol":"void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*)","imageIndex":5,"symbolLocation":560},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2765625,"name":"io.worker.4","threadState":{"x":[{"value":260},{"value":0},{"value":1024},{"value":0},{"value":0},{"value":160},{"value":0},{"value":0},{"value":6167211480},{"value":0},{"value":256},{"value":1099511628034},{"value":1099511628034},{"value":256},{"value":0},{"value":1099511628032},{"value":305},{"value":8281792216},{"value":0},{"value":46326380664},{"value":46326380728},{"value":6167212256},{"value":0},{"value":0},{"value":1024},{"value":1024},{"value":2048},{"value":46329902112},{"value":8}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6448611624},"cpsr":{"value":1610612736},"fp":{"value":6167211600},"sp":{"value":6167211456},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448346380},"far":{"value":0}},"frames":[{"imageOffset":17676,"symbol":"__psynch_cvwait","symbolLocation":8,"imageIndex":11},{"imageOffset":28968,"symbol":"_pthread_cond_wait","symbolLocation":980,"imageIndex":17},{"symbol":"std::__fl::__libcpp_condvar_wait[abi:nn210000](_opaque_pthread_cond_t*, _opaque_pthread_mutex_t*)","inline":true,"imageIndex":5,"imageOffset":291268,"symbolLocation":4,"sourceLine":122,"sourceFile":"pthread.h"},{"imageOffset":291268,"sourceLine":30,"sourceFile":"condition_variable.cpp","symbol":"std::__fl::condition_variable::wait(std::__fl::unique_lock<std::__fl::mutex>&)","imageIndex":5,"symbolLocation":44},{"symbol":"void std::__fl::condition_variable::wait<fml::ConcurrentMessageLoop::WorkerMain()::$_0>(std::__fl::unique_lock<std::__fl::mutex>&, fml::ConcurrentMessageLoop::WorkerMain()::$_0)","inline":true,"imageIndex":5,"imageOffset":566748,"symbolLocation":40,"sourceLine":147,"sourceFile":"condition_variable.h"},{"imageOffset":566748,"sourceLine":75,"sourceFile":"concurrent_message_loop.cc","symbol":"fml::ConcurrentMessageLoop::WorkerMain()","imageIndex":5,"symbolLocation":140},{"symbol":"fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0::operator()() const","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":20,"sourceFile":"concurrent_message_loop.cc"},{"symbol":"decltype(std::declval<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>()()) std::__fl::__invoke[abi:nn210000]<fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0&&)","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":179,"sourceFile":"invoke.h"},{"symbol":"void std::__fl::__thread_execute[abi:nn210000]<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>(std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>&, std::__fl::__tuple_indices<...>)","inline":true,"imageIndex":5,"imageOffset":569248,"symbolLocation":484,"sourceLine":200,"sourceFile":"thread.h"},{"imageOffset":569248,"sourceLine":209,"sourceFile":"thread.h","symbol":"void* std::__fl::__thread_proxy[abi:nn210000]<std::__fl::tuple<std::__fl::unique_ptr<std::__fl::__thread_struct, std::__fl::default_delete<std::__fl::__thread_struct>>, fml::ConcurrentMessageLoop::ConcurrentMessageLoop(unsigned long)::$_0>>(void*)","imageIndex":5,"symbolLocation":560},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2765626,"name":"dart:io EventHandler","threadState":{"x":[{"value":4},{"value":0},{"value":0},{"value":6168309016},{"value":16},{"value":0},{"value":0},{"value":0},{"value":0},{"value":510441520918888618},{"value":16},{"value":46327030976},{"value":0},{"value":970160351129755958},{"value":124928},{"value":4},{"value":363},{"value":8281792304},{"value":0},{"value":46314500672},{"value":0},{"value":67108864},{"value":2147483647},{"value":274877907},{"value":4294966296},{"value":1000000},{"value":519778853},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4350991184},"cpsr":{"value":536870912},"fp":{"value":6168309616},"sp":{"value":6168307952},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448357316},"far":{"value":0}},"frames":[{"imageOffset":28612,"symbol":"kevent","symbolLocation":8,"imageIndex":11},{"imageOffset":9313104,"sourceLine":459,"sourceFile":"eventhandler_macos.cc","symbol":"dart::bin::EventHandlerImplementation::EventHandlerEntry(unsigned long)","imageIndex":5,"symbolLocation":304},{"imageOffset":9473724,"sourceLine":65,"sourceFile":"thread_macos.cc","symbol":"dart::bin::ThreadStart(void*)","imageIndex":5,"symbolLocation":92},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"triggered":true,"id":2765635,"threadState":{"x":[{"value":0},{"value":0},{"value":0},{"value":0},{"value":6448311703},{"value":6169975200},{"value":110},{"value":18446726482597246976},{"value":8024816337489814026},{"value":8024816334541328906},{"value":2},{"value":4294967293},{"value":0},{"value":0},{"value":0},{"value":0},{"value":328},{"value":8281792288},{"value":0},{"value":6},{"value":85379},{"value":6169981152},{"value":8213790720,"symbolLocation":0,"symbol":"OBJC_IVAR_$_Object.isa"},{"value":1782},{"value":46314891584},{"value":9224126799},{"value":46336841248},{"value":46312560016},{"value":46334916992}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6448609496},"cpsr":{"value":1073741824},"fp":{"value":6169975056},"sp":{"value":6169975024},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448367080,"matchesCrashFrame":1},"far":{"value":0}},"queue":"com.apple.root.user-initiated-qos.cooperative","frames":[{"imageOffset":38376,"symbol":"__pthread_kill","symbolLocation":8,"imageIndex":11},{"imageOffset":26840,"symbol":"pthread_kill","symbolLocation":296,"imageIndex":17},{"imageOffset":493456,"symbol":"abort","symbolLocation":148,"imageIndex":18},{"imageOffset":91948,"symbol":"__abort_message","symbolLocation":132,"imageIndex":19},{"imageOffset":13704,"symbol":"demangling_terminate_handler()","symbolLocation":296,"imageIndex":19},{"imageOffset":149652,"symbol":"_objc_terminate()","symbolLocation":156,"imageIndex":20},{"imageOffset":79708,"symbol":"std::__terminate(void (*)())","symbolLocation":16,"imageIndex":19},{"imageOffset":89060,"symbol":"__cxxabiv1::failed_throw(__cxxabiv1::__cxa_exception*)","symbolLocation":88,"imageIndex":19},{"imageOffset":8348,"symbol":"__cxa_throw","symbolLocation":92,"imageIndex":19},{"imageOffset":109188,"symbol":"objc_exception_throw","symbolLocation":448,"imageIndex":20},{"imageOffset":965344,"symbol":"+[NSException raise:format:]","symbolLocation":128,"imageIndex":12},{"imageOffset":745448,"symbol":"_AVAE_CheckAndReturnErr(char const*, int, char const*, char const*, bool, int, NSError**)","symbolLocation":400,"imageIndex":21},{"imageOffset":794116,"symbol":"AVAudioEngineGraph::RemoveNode(AVAudioNode*, NSError**)","symbolLocation":888,"imageIndex":21},{"imageOffset":842440,"symbol":"-[AVAudioNode didDetachFromEngine:error:]","symbolLocation":80,"imageIndex":21},{"imageOffset":939956,"symbol":"AVAudioEngineImpl::DetachNode(AVAudioNode*, bool, NSError**)","symbolLocation":368,"imageIndex":21},{"imageOffset":972620,"symbol":"-[AVAudioEngine detachNode:]","symbolLocation":60,"imageIndex":21},{"imageOffset":25116,"sourceLine":191,"sourceFile":"CoreAudioSession.swift","symbol":"specialized CoreAudioSession.playSweepAndRecord(sweepSamples:outputChannel:inputChannel:onRms:)","imageIndex":0,"symbolLocation":144},{"imageOffset":11669,"sourceLine":100,"sourceFile":"AudioChannel.swift","symbol":"closure #2 in AudioChannel.handlePlaySweepAndRecord(call:result:)","imageIndex":0,"symbolLocation":1},{"imageOffset":15013,"symbol":"<deduplicated_symbol>","symbolLocation":1,"imageIndex":0},{"imageOffset":14153,"sourceFile":"\/<compiler-generated>","symbol":"specialized thunk for @escaping @isolated(any) @callee_guaranteed @async () -> (@out A)","symbolLocation":1,"imageIndex":0},{"imageOffset":16741,"symbol":"partial apply for specialized thunk for @escaping @isolated(any) @callee_guaranteed @async () -> (@out A)","symbolLocation":1,"imageIndex":0},{"imageOffset":52933,"symbol":"completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*)","symbolLocation":1,"imageIndex":22}]},{"id":2766239,"frames":[],"threadState":{"x":[{"value":6158331904},{"value":120083},{"value":6157795328},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6158331904},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448589832},"far":{"value":0}}},{"id":2766396,"name":"caulk.messenger.shared:17","threadState":{"x":[{"value":14},{"value":46323843098},{"value":0},{"value":6159478890},{"value":46323843072},{"value":25},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8281796592},{"value":0},{"value":46323638624},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6659608064},"cpsr":{"value":2147483648},"fp":{"value":6159478656},"sp":{"value":6159478624},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448331696},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7680,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":23},{"imageOffset":7340,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":23},{"imageOffset":6476,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":23},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2766397,"name":"caulk.messenger.shared:high","threadState":{"x":[{"value":14},{"value":80903},{"value":80903},{"value":15},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":1},{"value":46310109720},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8281796592},{"value":0},{"value":46323639520},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6659608064},"cpsr":{"value":2147483648},"fp":{"value":6160625536},"sp":{"value":6160625504},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448331696},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7680,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":23},{"imageOffset":7340,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":23},{"imageOffset":6476,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":23},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2766501,"name":"com.apple.audio.toolbox.AUScheduledParameterRefresher","threadState":{"x":[{"value":14},{"value":46336637622},{"value":0},{"value":6171652230},{"value":46336637568},{"value":53},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8281796592},{"value":0},{"value":46323645368},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6659608064},"cpsr":{"value":2147483648},"fp":{"value":6171651968},"sp":{"value":6171651936},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448331696},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7680,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":23},{"imageOffset":7340,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":23},{"imageOffset":6476,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":23},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2766502,"name":"caulk::deferred_logger","threadState":{"x":[{"value":14},{"value":17587891081215},{"value":0},{"value":1},{"value":0},{"value":1},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":4324261912},{"value":18446744073709551615},{"value":4095},{"value":6172749544},{"value":18446744073709551580},{"value":8281796592},{"value":0},{"value":46323645816},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6659608064},"cpsr":{"value":2147483648},"fp":{"value":6172749696},"sp":{"value":6172749664},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448331696},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7680,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":23},{"imageOffset":7340,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":23},{"imageOffset":6476,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":23},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2766511,"name":"com.apple.audio.IOThread.client","threadState":{"x":[{"value":14},{"value":100099},{"value":0},{"value":0},{"value":0},{"value":32},{"value":4792168800},{"value":0},{"value":1},{"value":510441520918888618},{"value":1099511628032},{"value":1099511628034},{"value":0},{"value":46336599568},{"value":0},{"value":116232385},{"value":18446744073709551579},{"value":8281796600},{"value":0},{"value":46312954680},{"value":46312954672},{"value":46312954800},{"value":8258765832,"symbolLocation":0,"symbol":"StaticContainer<HALC_ShellInfo_Statics>::s_statics_initialized (.0)"},{"value":8258764800,"symbolLocation":2224,"symbol":"sVarispeedRateTable"},{"value":46310964144},{"value":0},{"value":6507561831},{"value":6174993984},{"value":46312953856}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6659728016},"cpsr":{"value":1610612736},"fp":{"value":6174993680},"sp":{"value":6174993664},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448331708},"far":{"value":0}},"frames":[{"imageOffset":3004,"symbol":"semaphore_wait_signal_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":127632,"symbol":"caulk::mach::semaphore::wait_signal_or_error(caulk::mach::semaphore&)","symbolLocation":36,"imageIndex":23},{"imageOffset":2103876,"symbol":"HALC_ProxyIOContext::IOWorkLoop()","symbolLocation":4952,"imageIndex":24},{"imageOffset":2097232,"symbol":"invocation function for block in HALC_ProxyIOContext::HALC_ProxyIOContext(unsigned int, unsigned int)","symbolLocation":172,"imageIndex":24},{"imageOffset":3924144,"symbol":"HALC_IOThread::Entry(void*)","symbolLocation":88,"imageIndex":24},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]},{"id":2766513,"frames":[],"threadState":{"x":[{"value":6175567872},{"value":0},{"value":6175031296},{"value":0},{"value":278532},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6175567872},"esr":{"value":0},"pc":{"value":6448589832},"far":{"value":0}}},{"id":2766812,"name":"HIE: __ 3b7cb4d234b66b58 2026-04-19 18:23:19.247","threadState":{"x":[{"value":0},{"value":8589934595},{"value":103079220499},{"value":504757441598035},{"value":15483357102080},{"value":504757441527808},{"value":44},{"value":0},{"value":6448545792,"symbolLocation":20,"symbol":"panic"},{"value":1},{"value":46666826408},{"value":7},{"value":3},{"value":46309919776},{"value":8258499400,"symbolLocation":0,"symbol":"_NSConcreteMallocBlock"},{"value":8258499400,"symbolLocation":0,"symbol":"_NSConcreteMallocBlock"},{"value":18446744073709551569},{"value":8281797304},{"value":0},{"value":0},{"value":44},{"value":504757441527808},{"value":15483357102080},{"value":504757441598035},{"value":8589934595},{"value":6157757712},{"value":103079220499},{"value":18446744073709550527},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6448407924},"cpsr":{"value":2147483648},"fp":{"value":6157757696},"sp":{"value":6157757616},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6448331828},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":79220,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":11},{"imageOffset":200944,"symbol":"thread_suspend","symbolLocation":108,"imageIndex":11},{"imageOffset":222176,"symbol":"SOME_OTHER_THREAD_SWALLOWED_AT_LEAST_ONE_EXCEPTION","symbolLocation":20,"imageIndex":25},{"imageOffset":342672,"symbol":"__NSThread__start__","symbolLocation":732,"imageIndex":26},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":17},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":17}]}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4309680128,
    "CFBundleShortVersionString" : "1.0.0",
    "CFBundleIdentifier" : "com.example.kenethFrequency",
    "size" : 49152,
    "uuid" : "c33c4478-8ca2-3888-9615-e3bb059b53f8",
    "path" : "\/Users\/USER\/Documents\/*\/keneth_frequency.app\/Contents\/MacOS\/keneth_frequency",
    "name" : "keneth_frequency",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4310171648,
    "CFBundleShortVersionString" : "0.0.1",
    "CFBundleIdentifier" : "org.cocoapods.share-plus",
    "size" : 32768,
    "uuid" : "d6edd5af-3339-36f1-8519-e443253a051b",
    "path" : "\/Users\/USER\/Documents\/*\/keneth_frequency.app\/Contents\/Frameworks\/share_plus.framework\/Versions\/A\/share_plus",
    "name" : "share_plus",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4309876736,
    "CFBundleShortVersionString" : "0.0.1",
    "CFBundleIdentifier" : "org.cocoapods.shared-preferences-foundation",
    "size" : 65536,
    "uuid" : "ca8d4221-265e-3e96-880c-c33957897862",
    "path" : "\/Users\/USER\/Documents\/*\/keneth_frequency.app\/Contents\/Frameworks\/shared_preferences_foundation.framework\/Versions\/A\/shared_preferences_foundation",
    "name" : "shared_preferences_foundation",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4310319104,
    "CFBundleShortVersionString" : "3.52.0",
    "CFBundleIdentifier" : "org.cocoapods.sqlite3",
    "size" : 950272,
    "uuid" : "c749cda5-6df3-3208-bea8-247b044c9bb9",
    "path" : "\/Users\/USER\/Documents\/*\/keneth_frequency.app\/Contents\/Frameworks\/sqlite3.framework\/Versions\/A\/sqlite3",
    "name" : "sqlite3",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4311810048,
    "CFBundleShortVersionString" : "0.0.1",
    "CFBundleIdentifier" : "org.cocoapods.sqlite3-flutter-libs",
    "size" : 16384,
    "uuid" : "4d3a3695-77f6-3fa1-abf9-34408ca00bd9",
    "path" : "\/Users\/USER\/Documents\/*\/keneth_frequency.app\/Contents\/Frameworks\/sqlite3_flutter_libs.framework\/Versions\/A\/sqlite3_flutter_libs",
    "name" : "sqlite3_flutter_libs",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4341678080,
    "CFBundleShortVersionString" : "1.0",
    "CFBundleIdentifier" : "io.flutter.flutter-macos",
    "size" : 13352960,
    "uuid" : "4c4c44fc-5555-3144-a173-27fbbe0f0376",
    "path" : "\/Users\/USER\/Documents\/*\/keneth_frequency.app\/Contents\/Frameworks\/FlutterMacOS.framework\/Versions\/A\/FlutterMacOS",
    "name" : "FlutterMacOS",
    "CFBundleVersion" : "1.0"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4335681536,
    "size" : 49152,
    "uuid" : "a4dd56f1-375a-3540-844b-5e397f0b78b3",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4665081856,
    "CFBundleShortVersionString" : "1.0",
    "CFBundleIdentifier" : "io.flutter.flutter.app",
    "size" : 6782976,
    "uuid" : "efc96520-7504-3c37-8068-4966f7369c25",
    "path" : "\/Users\/USER\/Documents\/*\/keneth_frequency.app\/Contents\/Frameworks\/App.framework\/Versions\/A\/App",
    "name" : "App",
    "CFBundleVersion" : "1.0"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4700372992,
    "CFBundleShortVersionString" : "350.38",
    "CFBundleIdentifier" : "com.apple.AGXMetalG17G",
    "size" : 10190848,
    "uuid" : "c44193ee-a732-3f50-acb5-a6d3a6ca2a27",
    "path" : "\/System\/Library\/Extensions\/AGXMetalG17G.bundle\/Contents\/MacOS\/AGXMetalG17G",
    "name" : "AGXMetalG17G",
    "CFBundleVersion" : "350.38"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4673880064,
    "CFBundleShortVersionString" : "1.0",
    "CFBundleIdentifier" : "io.flutter.flutter.native-assets.objective-c",
    "size" : 81920,
    "uuid" : "cc8396a6-de66-3b41-8a7e-b9de4b42d04b",
    "path" : "\/Users\/USER\/Documents\/*\/keneth_frequency.app\/Contents\/Frameworks\/objective_c.framework\/Versions\/A\/objective_c",
    "name" : "objective_c",
    "CFBundleVersion" : "1.0"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4332191744,
    "CFBundleShortVersionString" : "1.14",
    "CFBundleIdentifier" : "com.apple.audio.units.Components",
    "size" : 1294336,
    "uuid" : "dd44ad41-2925-3a96-ae04-9a68575a3549",
    "path" : "\/System\/Library\/Components\/CoreAudio.component\/Contents\/MacOS\/CoreAudio",
    "name" : "CoreAudio",
    "CFBundleVersion" : "1.14"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6448328704,
    "size" : 250512,
    "uuid" : "51565b39-f595-3e96-a217-fef29815057a",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6448869376,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.CoreFoundation",
    "size" : 5626976,
    "uuid" : "04941709-2330-3bf8-9213-6d33964db448",
    "path" : "\/System\/Library\/Frameworks\/CoreFoundation.framework\/Versions\/A\/CoreFoundation",
    "name" : "CoreFoundation",
    "CFBundleVersion" : "4424.1.402"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6664433664,
    "CFBundleShortVersionString" : "2.1.1",
    "CFBundleIdentifier" : "com.apple.HIToolbox",
    "size" : 3125344,
    "uuid" : "bcb81496-c81f-3d3e-a617-ccca047989e0",
    "path" : "\/System\/Library\/Frameworks\/Carbon.framework\/Versions\/A\/Frameworks\/HIToolbox.framework\/Versions\/A\/HIToolbox",
    "name" : "HIToolbox"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6520627200,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.AppKit",
    "size" : 24259264,
    "uuid" : "59e23bd5-d01e-305a-b96f-a5790356049a",
    "path" : "\/System\/Library\/Frameworks\/AppKit.framework\/Versions\/C\/AppKit",
    "name" : "AppKit",
    "CFBundleVersion" : "2685.50.120"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6444564480,
    "size" : 679624,
    "uuid" : "9f682dcf-340c-3bfa-bcdd-dd702f30313e",
    "path" : "\/usr\/lib\/dyld",
    "name" : "dyld"
  },
  {
    "size" : 0,
    "source" : "A",
    "base" : 0,
    "uuid" : "00000000-0000-0000-0000-000000000000"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6448582656,
    "size" : 52028,
    "uuid" : "e7a73008-0c09-31e3-9dd9-0c61652f0e85",
    "path" : "\/usr\/lib\/system\/libsystem_pthread.dylib",
    "name" : "libsystem_pthread.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6447095808,
    "size" : 528120,
    "uuid" : "66ebd321-6899-3863-ba24-5cfc3076a0cb",
    "path" : "\/usr\/lib\/system\/libsystem_c.dylib",
    "name" : "libsystem_c.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6448218112,
    "size" : 108384,
    "uuid" : "e8d325ed-3b97-325e-b494-b1b0ff93d133",
    "path" : "\/usr\/lib\/libc++abi.dylib",
    "name" : "libc++abi.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6444007424,
    "size" : 338764,
    "uuid" : "2e858e25-1ff6-3da6-84f6-911630620512",
    "path" : "\/usr\/lib\/libobjc.A.dylib",
    "name" : "libobjc.A.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 9223000064,
    "CFBundleShortVersionString" : "1.0",
    "CFBundleIdentifier" : "com.apple.audio.AVFAudio",
    "size" : 1321472,
    "uuid" : "8e4d44ee-1b59-3dc5-bac8-fd96078883d4",
    "path" : "\/System\/Library\/Frameworks\/AVFAudio.framework\/Versions\/A\/AVFAudio",
    "name" : "AVFAudio"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 10811482112,
    "size" : 569494,
    "uuid" : "02634765-cb69-3c2b-9cce-10103cbea22a",
    "path" : "\/usr\/lib\/swift\/libswift_Concurrency.dylib",
    "name" : "libswift_Concurrency.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6659600384,
    "CFBundleShortVersionString" : "1.0",
    "CFBundleIdentifier" : "com.apple.audio.caulk",
    "size" : 168000,
    "uuid" : "2bdd6811-ce34-3098-9833-10d9f74b7ffc",
    "path" : "\/System\/Library\/PrivateFrameworks\/caulk.framework\/Versions\/A\/caulk",
    "name" : "caulk"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6500294656,
    "CFBundleShortVersionString" : "5.0",
    "CFBundleIdentifier" : "com.apple.audio.CoreAudio",
    "size" : 7954080,
    "uuid" : "72080a9b-8c5b-3e6d-8de7-0f86c3e698ec",
    "path" : "\/System\/Library\/Frameworks\/CoreAudio.framework\/Versions\/A\/CoreAudio",
    "name" : "CoreAudio",
    "CFBundleVersion" : "5.0"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6572949504,
    "CFBundleShortVersionString" : "1.22",
    "CFBundleIdentifier" : "com.apple.HIServices",
    "size" : 439136,
    "uuid" : "3aa36b9f-7d37-35ff-8034-a16dabfe5981",
    "path" : "\/System\/Library\/Frameworks\/ApplicationServices.framework\/Versions\/A\/Frameworks\/HIServices.framework\/Versions\/A\/HIServices",
    "name" : "HIServices"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6474477568,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.Foundation",
    "size" : 16654816,
    "uuid" : "8e9a5c62-7e95-3047-81e7-735ae1aee5f8",
    "path" : "\/System\/Library\/Frameworks\/Foundation.framework\/Versions\/C\/Foundation",
    "name" : "Foundation",
    "CFBundleVersion" : "4424.1.402"
  }
],
  "sharedCache" : {
  "base" : 6443433984,
  "size" : 5978570752,
  "uuid" : "2d40543a-792e-37b8-978d-3d7030e1aa81"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)\nWritable regions: Total=209.1M written=689K(0%) resident=689K(0%) swapped_out=0K(0%) unallocated=208.4M(100%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nAccelerate framework               128K        1 \nActivity Tracing                   256K        1 \nAttributeGraph Data               1024K        1 \nColorSync                           16K        1 \nCoreAnimation                      656K       29 \nCoreGraphics                        32K        2 \nCoreUI image data                  400K        3 \nFoundation                          48K        2 \nKernel Alloc Once                   32K        1 \nMALLOC                            93.8M       30 \nMALLOC guard page                 4016K        4 \nMemory Tag 22                     64.0M        1 \nSTACK GUARD                       56.3M       18 \nStack                             20.6M       20 \nVM_ALLOCATE                       25.3M       42 \nVM_ALLOCATE (reserved)             768K        1         reserved VM address space (unallocated)\n__AUTH                            5945K      625 \n__AUTH_CONST                      88.5M     1011 \n__CTF                               824        1 \n__DATA                            34.4M      969 \n__DATA_CONST                      34.9M     1025 \n__DATA_DIRTY                      8304K      868 \n__FONT_DATA                        2352        1 \n__LINKEDIT                       576.2M       12 \n__OBJC_RO                         79.1M        1 \n__OBJC_RW                         2597K        1 \n__TEXT                             1.2G     1050 \n__TPRO_CONST                       128K        2 \nmapped file                      295.4M       40 \npage table in kernel               689K        1 \nshared memory                     3744K       17 \n===========                     =======  ======= \nTOTAL                              2.6G     5781 \nTOTAL, minus reserved VM space     2.6G     5781 \n",
  "legacyInfo" : {
  "threadTriggered" : {
    "queue" : "com.apple.root.user-initiated-qos.cooperative"
  }
},
  "logWritingSignature" : "2dd2ca52a859d773372b6a17bb7d26d1e1612793",
  "bug_type" : "309",
  "roots_installed" : 0,
  "trmStatus" : 1,
  "trialInfo" : {
  "rollouts" : [
    {
      "rolloutId" : "64c17a9925d75a7281053d4c",
      "factorPackIds" : [
        "64d29746ad29a465b3bbeace"
      ],
      "deploymentId" : 240000002
    },
    {
      "rolloutId" : "695fd05d8ca5554688521e5e",
      "factorPackIds" : [
        "695fd08781fcd20ded79c1d3",
        "695fd0d28ca5554688521e5f",
        "695fd09c8774dc09015a80e9",
        "695fd0b18774dc09015a80ea"
      ],
      "deploymentId" : 3
    }
  ],
  "experiments" : [
    {
      "treatmentId" : "252b90da-916c-46c5-951f-bbff90605fb1",
      "experimentId" : "6913d889c90a1163a054ec41",
      "deploymentId" : 400000010
    },
    {
      "treatmentId" : "3145275e-2939-4f2a-994f-b57009c33642",
      "experimentId" : "69bc43737856540bea5e9184",
      "deploymentId" : 400000001
    }
  ]
}
}

Model: Mac17,4, BootROM 18000.101.7, proc 10:4:6:0 processors, 32 GB, SMC 
Graphics: Apple M5, Apple M5, Built-In
Display: Color LCD, 2880 x 1864 Retina, Main, MirrorOff, Online
Memory Module: LPDDR5, Samsung
AirPort: chip id: 0x11 api 1.2 firmware [Rev 72.29.721 N1B1 devFused=0] phy [20.1.62.0], core80211 [324.29.751 N1_silicon_b ], Apr  5 2026 21:19:05 version XBS_BUILD_TAG GIT_DESCRIBE FWID chip id: 0x11 api 1.2 firmware [Rev 72.29.721 N1B1 devFused=0] phy [20.1.62.0], core80211 [324.29.751 N1_silicon_b ]
IO80211_driverkit-1555.23 "IO80211_driverkit-1555.23" Apr  5 2026 21:03:59
AirPort: 
Bluetooth: Version (null), 0 services, 0 devices, 0 incoming serial ports
Network Service: Wi-Fi, AirPort, en0
Thunderbolt Bus: MacBook Air, Apple Inc.
Thunderbolt Bus: MacBook Air, Apple Inc.

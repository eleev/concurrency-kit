# concurrency-kit [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)

[![Platforms](https://img.shields.io/badge/platforms-iOS-yellow.svg)]()
[![Language](https://img.shields.io/badge/language-Swift-orange.svg)]()
[![CocoaPod](https://img.shields.io/badge/pod-1.0.0-lightblue.svg)]()
[![Build Status](https://travis-ci.org/jVirus/extensions-kit.svg?branch=master)](https://travis-ci.org/jVirus/extensions-kit)
[![Coverage](https://codecov.io/gh/jVirus/extensions-kit/branch/master/graph/badge.svg)](https://codecov.io/gh/jVirus/extensions-kit)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()

**Last Update: 10/March/2019.**

![](logo-concurrency_kit.png)

### If you like the project, please give it a star ⭐ It will show the creator your appreciation and help others to discover the repo.

# ✍️ About
🚄 Concurency abstractions framework for `iOS` development [`Task`, `Atomic`, `Lock`, etc.].

# 🏗 Installation
## CocoaPods
`concurrency-kit` is availabe via `CocoaPods`

```
pod 'concurrency-kit', '~> 1.0.0' 
```
## Manual
You can always use `copy-paste` the sources method 😄. Or you can compile the framework and include it with your project.

# 🔥 Features
- **Atomics** - syncronization primitive that is implemented in several forms: `Generic`, `Int` and `Bool`.
  - `Fast`. Under the hood a mutex (`pthread_mutex_lock`) that is more efficient than `OSSpinLock` and faster than `NSLock`.
  - `Throwable`. You can safely throw `Errors` and be able to delegate the handling.
- **Locks** - contains a number of locks, such as:
  - `UnfairLock` - A lock which causes a thread trying to acquire it to simply wait in a loop ("spin") while repeatedly checking if the lock is available.
  - `ReadWriteLock` - An `RW` lock allows concurrent access for read-only operations, while write operations require exclusive access.
  - `Mutex` - Allows only one thread to be active in a given region of code.
- **DispatchQueue+Extensions** - extended `DispatchQueue`, where `asyncAfter` and `once` methods can be performed. 
- **Task** - A unit of work that performs a specific job and usually runs concurrently with other tasks.
  - Tasks can be `grouped` - meaning that you are able to compose the tasks, similar to `Futures & Promises` and execute then serially.
  - Tasks can be `sequenced` - meaning that you are able to compose different `groups` and execute then concurrently. No need to repeadetly use `DispatchGroup` (`enter`/`leave`). 
- **Thoroughly** tested.

# 📚 Examples
**In development**

# 👨‍💻 Author 
[Astemir Eleev](https://github.com/jVirus)

# 🔖 Licence
The project is available under [MIT licence](https://github.com/jVirus/concurrency-kit/blob/master/LICENSE)

---
description: Java开发指南。开发Java代码时使用。
---

# Development Guidelines

## Creating and Destroying Objects

- Consider static factory methods instead of constructors
- Consider a builder when faced with many constructor parameters
- Enforce the singleton property with a private constructor or an enum type
- Enforce noninstantiability with a private constructor
- Prefer dependency injection to hardwiring resources
- Avoid creating unnecessary objects
- Eliminate obsolete object references
- Avoid finalizers and cleaners
- Prefer try-with-resources to try-finally

## Methods Common to All Objects

- Obey the general contract when overriding equals
- Always override hashCode when you override equals
- Always override toString
- Override clone judiciously
- Consider implementing Comparable

## Classes and Interfaces

- Minimize the accessibility of classes and members
- In public classes, use accessor methods, not public fields
- Minimize mutability
- Favor composition over inheritance
- Design and document for inheritance or else prohibit it
- Prefer interfaces to abstract classes
- Design interfaces for posterity
- Use interfaces only to define types
- Prefer class hierarchies to tagged classes
- Favor static member classes over nonstatic
- Limit source files to a single top-level class

## Generics

- Don't use raw types
- Eliminate unchecked warnings
- Prefer lists to arrays
- Favor generic types
- Favor generic methods
- Use bounded wildcards to increase API flexibility
- Combine generics and varargs judiciously
- Consider typesafe heterogeneous containers

## Enums and Annotations

- Use enums instead of int constants
- Use instance fields instead of ordinals
- Use EnumSet instead of bit fields
- Use EnumMap instead of ordinal indexing
- Emulate extensible enums with interfaces
- Prefer annotations to naming patterns
- Consistently use the Override annotation
- Use marker interfaces to define types

## Lambdas and Streams

- Prefer lambdas to anonymous classes
- Prefer method references to lambdas
- Favor the use of standard functional interfaces
- Use streams judiciously
- Prefer side-effect-free functions in streams
- Prefer Collection to Stream as a return type
- Use caution when making streams parallel

## Methods

- Check parameters for validity
- Make defensive copies when needed
- Design method signatures carefully
- Use overloading judiciously
- Use varargs judiciously
- Return empty collections or arrays, not nulls
- Return optionals judiciously
- Write doc comments for all exposed API elements

## General Programming

- Minimize the scope of local variables
- Prefer for-each loops to traditional for loops
- Know and use the libraries
- Avoid float and double if exact answers are required
- Prefer primitive types to boxed primitives
- Avoid strings where other types are more appropriate
- Beware the performance of string concatenation
- Refer to objects by their interfaces
- Prefer interfaces to reflection
- Use native methods judiciously
- Optimize judiciously
- Adhere to generally accepted naming conventions

## Exceptions

- Use exceptions only for exceptional conditions
- Use checked exceptions for recoverable conditions and runtime exceptions for programming errors
- Avoid unnecessary use of checked exceptions
- Favor the use of standard exceptions
- Throw exceptions appropriate to the abstraction
- Document all exceptions thrown by each method
- Include failure-capture information in detail messages
- Strive for failure atomicity
- Don't ignore exceptions

## Concurrency

- Synchronize access to shared mutable data
- Avoid excessive synchronization
- Prefer executors, tasks, and streams to threads
- Prefer concurrency utilities to wait and notify
- Document thread safety
- Use lazy initialization judiciously
- Don't depend on the thread scheduler

## Serialization

- Prefer alternatives to Java serialization
- Implement Serializable with great caution
- Consider using a custom serialized form
- Write readObject methods defensively
- For instance control, prefer enum types to readResolve
- Consider serialization proxies instead of serialized instances

# Best Practices

concurrency_guidelines:

- Try to not maintain state in the class

functional_programming_guidelines:

- Try to use immutable objects
- Try to not mutate the state of the objects

data_oriented_programming_pillars:

- Separate code from data
- Represent data with generic data structures
- Data should be immutable
- Use pure functions to manipulate data
- Keep data flat and denormalized
- Keep data generic until it needs to be specific
- Data integrity is maintained through validation functions
- Data access should be flexible and generic
- Data transformation should be explicit and traceable
- Data flow should be unidirectional
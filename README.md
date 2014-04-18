NTJsonModel
===========

[in development] A high performance model object wrapper for JSON.

Proof of concept notes
----------------------

Seems like this all makes sense, but there are some gotchas:

 - Best case for property access performance is NSDictionary access. Minimum would be 1 lookup for the property info
   and a second one to get the property value (either from the cache or from the dictionary its self.)

 - Lots of work to do on transforming values still (only a couple type are supported and no transformations.)
 
 - Need to work out exactly how properties will be defined. (What is the right mix between "magical"
 syntax and explicit declarations?)
 
 - Need to detect when properties are defined without @dynamic - these will have properties and
 a backing store. throw exception.
 
 - We can use an associated objects as our cache store.
 

Done-ish
--------
   
 - ~~Continuing on ideas for optimizing for read-only modes. Instances are created as immutable by default, there
   is an explicit action to make mutable (mutableCopy.) In mutable mode, we can eliminate caching to simplify things.
   This removes the requirement for the "rootModel" pointer and also will get us to one pointer for the dictionary 
   (which is either mutable or not.) init creates mutable instances, also mutableModelWithJson:.~~
   
 - ~~need to handle setting a "normal" array of object into an array (a transformation I suppose.)~~
   
 - ~~Many complications arise from supporting immutable and mutable modes. Actually many complications arise from supporting
   the mutable mode. Read only objects would be much simpler to maintain.~~ Solution: objects must be copied to move between
   mutable and immutable states.
   
 - ~~Array performance may suffer when doing things like sorting (sorting an array of items within a root model.)~~ Handled
 by requiring the mutableCopy and restructuring now array caching is done (eliminate sparse array)
 


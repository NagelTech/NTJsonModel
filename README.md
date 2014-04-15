NTJsonModel
===========

[in development] A high performance model object wrapper for JSON.

Proof of concept notes
----------------------

Seems like this all makes sense, but there are some gotchas:

 - Best case for property access performance is NSDictionary access. Minimum would be 1 lookup for the property info
   and a second one to get the property value (either from the cache or from the dictionary its self.)

 - Array performance may suffer when doing things like sorting (sorting an array of items within a root model.)
 
 - Many complications arise from supporting immutable and mutable modes. Actually many complications arise from supporting
   the mutable mode. Read only objects would be much simpler to maintain.
   
 - Lots of work to do on transforming values still (only a couple type are supported and no transformations.)
 
 - need to handle setting a "normal" array of object into an array (a transformation I suppose.)
 
 - Switch to "parent" model/array to make it easier to remove an item from it's parent. Introduce NTJsonModelContainer 
   procotol to encapsulate the common functionality. Both NTJsonModel and NTJsonModlArray will conform to it.
   
 - Continuing on ideas for optimizing for read-only modes. Instances are created as immutable by default, there
   is an explicit action to make mutable (mutableCopy.) In mutable mode, we can eliminate caching to simplify things.
   This removes the requirement for the "rootModel" pointer and also will get us to one pointer for the dictionary 
   (which is either mutable or not.) init creates mutable instances, also mutableModelWithJson:.
   

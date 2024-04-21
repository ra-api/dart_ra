# Modular API Builder

A package for creating a web server using a declarative approach.

The server, upon startup, iterates through the packages to build a registry based on them. This process occurs only once. Subsequently, when a request arrives, it parses the path and searches for the method to execute based on the package name, method name, and version. If the method name and version are not found but there is a package name, an error is returned indicating an incorrect version. Otherwise, it proceeds to process the parameters and prepares the context for the handle method.

When working with the package, we can inherit from Method to create new methods, DataType to create converters and validators (method parameters), and ResponseContentType to convert arbitrary objects into bytes.

Examples can be found in the example folder.

## Plugin API

- **Plugin** - ability to define hooks
- **PluginProvider** - hooks plus *PluginOptions*
- **PluginConsumer** - hooks and the ability to obtain *PluginOptions*

*PluginOptions* is available in *MethodCtx* and *DataTypeCtx* classes via generics.

### Hooks

- **ErrorHandleHook** (global, method)
- **ServerResponseHook** (global, method)
- **MethodRequestHook** (global, method)
namespace SFA.FCS.Worker.Common
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using System.Reflection.Emit;
    using NServiceBus;

    public static class DynamicTypeBuilder
    {
        private const string CommandNamespace = "FCS.Worker.Dynamic.Commands";
        private const string DynamicAssemblyName = "FcsWorkerDynamicCommands";

        public static object BuildCommandFrom<T>(T originalType)
        {
            Type lowestLevelType = originalType.GetType();

            Type commandType;

            if (lowestLevelType == typeof(object))
            {
                commandType = CompileResultType(typeof(T));
            }
            else
            {
                commandType = CompileResultType(lowestLevelType);
            }

            object destCommand = Activator.CreateInstance(commandType);

            foreach (PropertyInfo propertyInfo in originalType.GetType().GetProperties())
            {
                commandType.GetProperty(propertyInfo.Name)?.SetValue(destCommand, propertyInfo.GetValue(originalType));
            }

            return destCommand;
        }

        private static Type CompileResultType(Type fromType)
        {
            TypeBuilder tb = GetTypeBuilder($"{CommandNamespace}.{fromType.Name}");
            tb.DefineDefaultConstructor(MethodAttributes.Public | MethodAttributes.SpecialName | MethodAttributes.RTSpecialName);

            if (fromType.IsInterface)
            {
                tb.SetParent(typeof(object));
                tb.AddInterfaceImplementation(fromType);

                foreach (var propertyInfo in GetAllProperties(fromType))
                {
                    CreateProperty(tb, propertyInfo);
                }
            }
            else
            {
                tb.SetParent(fromType);
            }

            tb.AddInterfaceImplementation(typeof(ICommand));

            Type objectType = tb.CreateTypeInfo().AsType();
            return objectType;
        }

        private static TypeBuilder GetTypeBuilder(string typeName)
        {

            var assemblyName = new AssemblyName(DynamicAssemblyName);

            AssemblyBuilder assemblyBuilder = AssemblyBuilder.DefineDynamicAssembly(
                assemblyName,
                AssemblyBuilderAccess.Run);

            ModuleBuilder moduleBuilder = assemblyBuilder.DefineDynamicModule(DynamicAssemblyName);


            TypeBuilder tb = moduleBuilder.DefineType(typeName,
                    TypeAttributes.Public |
                    TypeAttributes.Class |
                    TypeAttributes.AutoClass |
                    TypeAttributes.AnsiClass |
                    TypeAttributes.BeforeFieldInit |
                    TypeAttributes.AutoLayout,
                    null);

            return tb;
        }

        private static void CreateProperty(TypeBuilder tb, PropertyInfo prop)
        {
            Type propertyType = prop.PropertyType;

            FieldBuilder fieldBuilder = tb.DefineField(
                "field_" + prop.Name,
                propertyType,
                FieldAttributes.Private);

            PropertyBuilder propBuilder = tb.DefineProperty(
                prop.Name,
                prop.Attributes | PropertyAttributes.HasDefault,
                propertyType,
                null);

            MethodBuilder getMethodBuilder = tb.DefineMethod(
                "get_" + prop.Name,
                MethodAttributes.Public | MethodAttributes.SpecialName | MethodAttributes.HideBySig | MethodAttributes.Final | MethodAttributes.Virtual | MethodAttributes.VtableLayoutMask,
                propertyType,
                Type.EmptyTypes);

            ILGenerator getIL = getMethodBuilder.GetILGenerator();
            // For an instance property, argument zero is the instance. Load the
            // instance, then load the private field and return, leaving the
            // field value on the stack.
            getIL.Emit(OpCodes.Ldarg_0);
            getIL.Emit(OpCodes.Ldfld, fieldBuilder);
            getIL.Emit(OpCodes.Ret);

            // Define the "set" accessor method for Number, which has no return
            // type and takes one argument of type int (Int32).
            MethodBuilder setMethodBuilder = tb.DefineMethod(
                "set_" + prop.Name,
                getMethodBuilder.Attributes,
                null,
                new[]
                {
                        propertyType
                });

            ILGenerator setIL = setMethodBuilder.GetILGenerator();
            // Load the instance and then the numeric argument, then store the
            // argument in the field.
            setIL.Emit(OpCodes.Ldarg_0);
            setIL.Emit(OpCodes.Ldarg_1);
            setIL.Emit(OpCodes.Stfld, fieldBuilder);
            setIL.Emit(OpCodes.Ret);

            // Last, map the "get" and "set" accessor methods to the
            // PropertyBuilder. The property is now complete.
            propBuilder.SetGetMethod(getMethodBuilder);
            propBuilder.SetSetMethod(setMethodBuilder);
        }

        private static IEnumerable<PropertyInfo> GetAllProperties(Type type)
        {
            var props = new List<PropertyInfo>(type.GetProperties());
            foreach (var interfaceType in type.GetInterfaces())
            {
                props.AddRange(GetAllProperties(interfaceType));
            }

            var tracked = new List<PropertyInfo>(props.Count);
            var duplicates = new List<PropertyInfo>(props.Count);
            foreach (var p in props)
            {
                var duplicate = tracked.SingleOrDefault(n => n.Name == p.Name && n.PropertyType == p.PropertyType);
                if (duplicate != null)
                {
                    duplicates.Add(p);
                }
                else
                {
                    tracked.Add(p);
                }
            }

            foreach (var d in duplicates)
            {
                props.Remove(d);
            }

            return props;
        }
    }
}
namespace AllocationDeliveryDomain.Endpoint.Tests.Helpers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System;
    using System.Collections;
    using System.Reflection;

    public static class AssertExtensions
    {


        public static void PropertyValuesAreEqual(object expected, object actual)
        {
            // Quick null / type sanity checks
            if (expected is null && actual is null) return;

            Assert.IsNotNull(expected, "Expected object is null while actual is not.");
            Assert.IsNotNull(actual, "Actual object is null while expected is not.");

            var expectedType = expected.GetType();
            var actualType = actual.GetType();

            // If types differ, fail early with a clear message
            if (expectedType != actualType)
            {
                Assert.Fail($"Type mismatch. Expected type {expectedType.FullName} but was {actualType.FullName}.");
            }

            PropertyInfo[] properties = expectedType.GetProperties(BindingFlags.Instance | BindingFlags.Public);

            foreach (PropertyInfo property in properties)
            {
                object expectedValue = property.GetValue(expected, null);
                object actualValue = property.GetValue(actual, null);

                // If both null => equal
                if (expectedValue is null && actualValue is null)
                    continue;

                // If only one is null => mismatch
                if (expectedValue is null || actualValue is null)
                {
                    Assert.Fail(
                        $"Property {property.DeclaringType.Name}.{property.Name} does not match. " +
                        $"Expected: {(expectedValue ?? "null")} but was: {(actualValue ?? "null")}");
                }

                // Determine if this is one of your domain types (recursive compare)
                bool isDomainType = false;
                var ns = expectedValue!.GetType().Namespace;
                if (!string.IsNullOrEmpty(ns))
                {
                    isDomainType = ns!.Contains("SFA.FCT", StringComparison.Ordinal);
                }

                // IList handling
                if (actualValue is IList actualList && expectedValue is IList expectedList)
                {
                    AssertListsAreEqual(property, expectedList, actualList);
                }
                else if (actualValue is IList || expectedValue is IList)
                {
                    Assert.Fail(
                        $"Property {property.DeclaringType.Name}.{property.Name} type mismatch. " +
                        $"One side is IList and the other is not.");
                }
                // Recurse into domain objects
                else if (isDomainType)
                {
                    PropertyValuesAreEqual(expectedValue, actualValue);
                }
                // Fallback to value equality
                else if (!Equals(expectedValue, actualValue))
                {
                    Assert.Fail(
                        $"Property {property.DeclaringType.Name}.{property.Name} does not match. " +
                        $"Expected: {expectedValue} but was: {actualValue}");
                }
            }
        }


        private static void AssertListsAreEqual(PropertyInfo property, IList expectedList, IList actualList)
        {
            if (actualList.Count != expectedList.Count)
            {
                Assert.Fail(
                    $"Property {property.PropertyType.Name}.{property.Name} does not match. " +
                    $"Expected IList containing {expectedList.Count} elements but was IList containing {actualList.Count} elements");
            }

            for (int i = 0; i < actualList.Count; i++)
            {
                PropertyValuesAreEqual(expectedList[i], actualList[i]);
            }
        }

    }
}

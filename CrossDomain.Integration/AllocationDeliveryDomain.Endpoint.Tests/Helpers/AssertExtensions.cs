namespace AllocationDeliveryDomain.Endpoint.Tests.Helpers
{
    using System.Collections;
    using System.Reflection;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    public static class AssertExtensions
    {
        public static void PropertyValuesAreEqual(object expected, object actual)
        {
            PropertyInfo[] properties = expected.GetType().GetProperties();

            foreach (PropertyInfo property in properties)
            {
                object expectedValue = property.GetValue(expected, null);
                object actualValue = property.GetValue(actual, null);

                bool isClass = false;
                if (expectedValue != null)
                {
                    var ns = expectedValue.GetType().UnderlyingSystemType.Namespace;
                    if (ns != null)
                    {
                        isClass = ns.Contains("SFA.FCT");
                    }
                }

                if (actualValue is IList)
                {
                    AssertListsAreEqual(property, (IList)expectedValue, (IList)actualValue);
                }
                else if (isClass)
                {
                    PropertyValuesAreEqual(expectedValue, actualValue);
                }
                else if (!Equals(expectedValue, actualValue))
                {
                    Assert.Fail("Property {0}.{1} does not match. Expected: {2} but was: {3}", property.DeclaringType.Name, property.Name, expectedValue, actualValue);
                }
            }
        }

        private static void AssertListsAreEqual(PropertyInfo property, IList expectedList, IList actualList)
        {
            if (actualList.Count != expectedList.Count)
            {
                Assert.Fail("Property {0}.{1} does not match. Expected IList containing {2} elements but was IList containing {3} elements", property.PropertyType.Name, property.Name, expectedList.Count, actualList.Count);
            }

            for (int i = 0; i < actualList.Count; i++)
            {
                PropertyValuesAreEqual(expectedList[i], actualList[i]);
            }
        }
    }
}

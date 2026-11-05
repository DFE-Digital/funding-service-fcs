namespace ADMonitoringDomain.Endpoint.Tests.Unit
{
    using System;
    using ADMonitoringDomain.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class SerializeToTypeExtensionsTests
    {
        public class Payload
        {
            public string Name { get; set; }

            public int Value { get; set; }
        }

        private class Holder : ISerializeToType
        {
            public object Object { get; set; }

            public string ObjectType { get; set; }

            public string SerializedXml { get; set; }
        }

        private static Holder CreateSerialized()
        {
            var holder = new Holder
            {
                Object = new Payload { Name = "abc", Value = 7 },
                ObjectType = typeof(Payload).AssemblyQualifiedName
            };
            holder.Serialize();
            return holder;
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Serialize_WithObjectAndType_PopulatesSerializedXml()
        {
            var holder = CreateSerialized();

            StringAssert.Contains(holder.SerializedXml, "<Name>abc</Name>");
            StringAssert.Contains(holder.SerializedXml, "<Value>7</Value>");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Serialize_WithNullObject_LeavesXmlUntouched()
        {
            var holder = new Holder { ObjectType = typeof(Payload).AssemblyQualifiedName };

            holder.Serialize();

            Assert.IsNull(holder.Object);
            Assert.IsNull(holder.SerializedXml);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Serialize_WithNullObjectType_ClearsObject()
        {
            var holder = new Holder { Object = new Payload() };

            holder.Serialize();

            Assert.IsNull(holder.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Serialize_WithUnknownObjectType_ThrowsArgumentException()
        {
            var holder = new Holder { Object = new Payload(), ObjectType = "Not.A.Real.Type, Nowhere" };

            try
            {
                holder.Serialize();
                Assert.Fail("Expected ArgumentException");
            }
            catch (ArgumentException)
            {
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SerializeGeneric_WithObjectAndType_PopulatesSerializedXml()
        {
            var holder = new Holder { Object = new Payload { Name = "xyz", Value = 1 }, ObjectType = "any" };

            holder.Serialize<Payload>();

            StringAssert.Contains(holder.SerializedXml, "<Name>xyz</Name>");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SerializeGeneric_WithNullObject_ClearsObject()
        {
            var holder = new Holder { ObjectType = "any" };

            holder.Serialize<Payload>();

            Assert.IsNull(holder.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Deserialize_RoundTripsObject()
        {
            var holder = CreateSerialized();
            holder.Object = null;

            holder.Deserialize();

            var payload = (Payload)holder.Object;
            Assert.AreEqual("abc", payload.Name);
            Assert.AreEqual(7, payload.Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Deserialize_WithBlankXml_ClearsObject()
        {
            var holder = new Holder { Object = new Payload(), SerializedXml = " " };

            holder.Deserialize();

            Assert.IsNull(holder.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Deserialize_WithNullOrUnknownObjectType_LeavesObjectUnchanged()
        {
            var existing = new Payload();
            var withoutType = new Holder { Object = existing, SerializedXml = "<Payload />" };
            var unknownType = new Holder { Object = existing, SerializedXml = "<Payload />", ObjectType = "Not.A.Real.Type, Nowhere" };

            withoutType.Deserialize();
            unknownType.Deserialize();

            Assert.AreSame(existing, withoutType.Object);
            Assert.AreSame(existing, unknownType.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeserializeGeneric_RoundTripsObject()
        {
            var holder = CreateSerialized();
            holder.Object = null;

            holder.Deserialize<Payload>();

            Assert.AreEqual("abc", ((Payload)holder.Object).Name);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeserializeGeneric_WithBlankXml_ClearsObject()
        {
            var holder = new Holder { Object = new Payload(), SerializedXml = null };

            holder.Deserialize<Payload>();

            Assert.IsNull(holder.Object);
        }
    }
}

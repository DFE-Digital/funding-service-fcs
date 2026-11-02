namespace FCT.Console.Config.Tests.Extraction
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using Config.Extraction.Crm;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;

    [TestClass]
    public class EntityTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TransformEntitiesToCsv_TransformsEntitiesIncludingKeys()
        {
            // Arrange
            List<Entity> entityList = new List<Entity>();
            

            for (int i = 0; i < 3; i++)
            {
                Entity entityToTransform = new Entity
                {
                    EntityState = EntityState.Created,
                    Id = Guid.NewGuid(),
                    LogicalName = "testEntity"
                };
                AttributeCollection attributes = new AttributeCollection
                {
                    {"col0", $"val0{i}"},
                    {"col1", $"val1{i}"},
                    {"col2", $"val2{i}"}
                };
                entityToTransform.Attributes = attributes;
                entityList.Add(entityToTransform);
            }

            const string line1 = "Some Col 0,Some Col 1,Some Col 2";
            const string line2 = "val00,val10,val20";
            const string line3 = "val01,val11,val21";
            const string line4 = "val02,val12,val22";

            StringBuilder builder = new StringBuilder();
            builder.AppendLine(line1);
            builder.AppendLine(line2);
            builder.AppendLine(line3);
            builder.AppendLine(line4);

            string expected = builder.ToString();
            IDictionary<string, string> columnLabels = new Dictionary<string, string>();
            columnLabels.Add("col0", "Some Col 0");
            columnLabels.Add("col1", "Some Col 1");
            columnLabels.Add("col2", "Some Col 2");
            CrmEntityRows crmEntityRows = new CrmEntityRows(entityList, columnLabels);
            // Act
            string actual = CrmEntityTransformer.TransformEntitiesToCsv(crmEntityRows);

            // Assert
            Assert.AreEqual(expected, actual);
        }
    }
}
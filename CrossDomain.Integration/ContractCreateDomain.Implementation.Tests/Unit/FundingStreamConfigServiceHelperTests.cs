namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class FundingStreamConfigServiceHelperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FilterProfileDeliverableStructure_KeepsProfileDeliverablesAndTheirAncestorsInCodeOrder()
        {
            var root = CreateDeliverable(10);
            var parent = CreateDeliverable(20, parentCode: 10);
            var profileDeliverable = CreateDeliverable(30, parentCode: 20, allowProfile: true);
            var nonProfileDeliverable = CreateDeliverable(5);
            var structure = new FSCDeliverableStructureDefinitionResponse
            {
                DeliverableStructureList = new List<DeliverableConfigurationType>
                {
                    profileDeliverable,
                    nonProfileDeliverable,
                    parent,
                    root
                }
            };

            var result = FundingStreamConfigServiceHelper.FilterProfileDeliverableStructure(structure);

            CollectionAssert.AreEqual(
                new[] { 10, 20, 30 },
                result.DeliverableStructureList.Select(item => item.DeliverableCode).ToArray());
            Assert.AreSame(root, result.DeliverableStructureList[0]);
            Assert.AreSame(parent, result.DeliverableStructureList[1]);
            Assert.AreSame(profileDeliverable, result.DeliverableStructureList[2]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FilterProfileDeliverableStructure_ReturnsEmptyListWhenNoDeliverableAllowsProfile()
        {
            var structure = new FSCDeliverableStructureDefinitionResponse
            {
                DeliverableStructureList = new List<DeliverableConfigurationType>
                {
                    CreateDeliverable(10),
                    CreateDeliverable(20, parentCode: 10)
                }
            };

            var result = FundingStreamConfigServiceHelper.FilterProfileDeliverableStructure(structure);

            Assert.AreEqual(0, result.DeliverableStructureList.Count);
        }

        private static DeliverableConfigurationType CreateDeliverable(int code, int? parentCode = null, bool allowProfile = false)
        {
            var deliverable = new DeliverableConfigurationType
            {
                DeliverableCode = code,
                ParentDetails = new DeliverableConfigurationTypeParentDetails
                {
                    ParentDeliverableCode = parentCode
                }
            };

            if (allowProfile)
            {
                deliverable.Settings.Add(new DeliverableSettingsType
                {
                    SettingCode = "allowprofile",
                    SettingValue = "Yes"
                });
            }

            return deliverable;
        }
    }
}

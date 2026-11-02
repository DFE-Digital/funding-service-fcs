namespace ContractManagementDomain.Endpoint.Tests.ContractApproved
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using AutoMapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using CorporateSchema = SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class ContractTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_TransformToCorporateSchemaContract_ShouldTransformWithRightDeliverables()
        {
            // arrange
            contract corpContract = GetCorporateContractFromFile("corporate_contract_EDSK-1579.json");
            Assert.IsNotNull(corpContract);

            ContractTransformer contractTransformer = new ContractTransformer();
            
            // act
            SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contract schemaContract = contractTransformer.TransformToCorporateSchemaContract(corpContract);
            
            // assert
            schemaContract.contracts.First().contractAllocations.ForEach(schemaAllocation =>
                {
                    var corpAllocation = corpContract.contracts.First().contractAllocations.Single(a =>
                        a.contractAllocationNumber == schemaAllocation.contractAllocationNumber);

                    var schemaDeliverables = FlattenDeliverables(schemaAllocation.contractDeliverables);

                    var corpAllocationDeliverables = corpAllocation.GetAllDeliverables();
                    Assert.AreEqual(corpAllocationDeliverables.Count, schemaDeliverables.Count, $"The number of deliverables on allocation: {schemaAllocation.contractAllocationNumber} is incorrect");

                    bool areAllTheDeliverableNamesPresent = corpAllocationDeliverables.Select(d => d.deliverable.deliverableName).All(corpDeliverableName =>
                        schemaDeliverables.Select(d => d.deliverable.deliverableName).Contains(corpDeliverableName));

                    Assert.IsTrue(areAllTheDeliverableNamesPresent, $"Not all the deliverale names for this allocation: {schemaAllocation.contractAllocationNumber}");
                });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_TransformToCorporateSchemaContract_ShouldTransformWithRightDeliverablesWhenThereAre2LevelsOfHierarchy()
        {
            // 'AEBC1819'
            contract corpContract = GetCorporateContractFromFile("corporate_contracts_withAEBC1819.json");

            Assert.IsNotNull(corpContract);

          
            ContractTransformer contractTransformer = new ContractTransformer();

            // act
            SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contract schemaContract = contractTransformer.TransformToCorporateSchemaContract(corpContract);
            
            // assert
            schemaContract.contracts.First().contractAllocations.ForEach(schemaAllocation =>
            {
                var corpAllocation = corpContract.contracts.First().contractAllocations.Single(a =>
                    a.contractAllocationNumber == schemaAllocation.contractAllocationNumber);

                var schemaDeliverables = FlattenDeliverables(schemaAllocation.contractDeliverables);

                var corpAllocationDeliverables = corpAllocation.GetAllDeliverables();
                Assert.AreEqual(corpAllocationDeliverables.Count, schemaDeliverables.Count, $"The number of deliverables on allocation: {schemaAllocation.contractAllocationNumber} is incorrect");

                bool areAllTheDeliverableNamesPresent = corpAllocationDeliverables.Select(d => d.deliverable.deliverableName).All(corpDeliverableName =>
                    schemaDeliverables.Select(d => d.deliverable.deliverableName).Contains(corpDeliverableName));

                Assert.IsTrue(areAllTheDeliverableNamesPresent, $"Not all the deliverale names for this allocation: {schemaAllocation.contractAllocationNumber}");
            });

            var schemaAllocationAEC = schemaContract.contracts.First().contractAllocations
                .Single(a => a.contractAllocationNumber == "AEC-529");

            Assert.AreEqual(1, schemaAllocationAEC.contractDeliverables.Count, "There should only be on top level deliverable");
            Assert.AreEqual(1, schemaAllocationAEC.contractDeliverables.First().deliverable.deliverableCode, "The top level deliverable should have a deliverable code of 1");
            Assert.AreEqual(2, schemaAllocationAEC.contractDeliverables.First().contractDeliverables.Count, "There should only be on top level deliverable");
            var deliverable13 = schemaAllocationAEC.contractDeliverables.First().contractDeliverables
                .Single(d => d.deliverable.deliverableCode == 13);

            Assert.AreEqual(0, deliverable13.contractDeliverables.Count, "Deliverable 13 does not have the right number of children");
            var deliverable14 = schemaAllocationAEC.contractDeliverables.First().contractDeliverables
                .Single(d => d.deliverable.deliverableCode == 14);

            Assert.AreEqual(5, deliverable14.contractDeliverables.Count, "Deliverable 14 does not have the right number of children");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_ShouldTransformAllocationTerminationAttributes()
        {
            DateTime stopNewStartsDate = DateTime.UtcNow.AddDays(1);
            const string newStartsSuspendedReason = "Inadequate Financial Health";
            DateTime fundingCessationDate = DateTime.UtcNow.AddDays(2);

            // arrange
            contract corporateContract = GetCorporateContractFromFile("corporate_contract_EDSK-1579.json");
            contractAllocationsContractAllocation inputAllocation = corporateContract.contracts.First().contractAllocations.First();

            inputAllocation.StopNewStartsDate = stopNewStartsDate;
            inputAllocation.NewStartsSuspendedReason = newStartsSuspendedReason;
            inputAllocation.FundingCessationDate = fundingCessationDate;

            ContractTransformer contractTransformer = new ContractTransformer();

            // act
            CorporateSchema.contract schemaContract = contractTransformer.TransformToCorporateSchemaContract(corporateContract);

            // assert
            CorporateSchema.contractAllocationsContractAllocation transformedAllocation = schemaContract.contracts.First().contractAllocations.First();

            Assert.IsNotNull(transformedAllocation.allocationTerminationAttrs, "allocationTerminationAttrs is null");
            Assert.AreEqual(stopNewStartsDate, transformedAllocation.allocationTerminationAttrs.stopNewStartsFromDate,
                "Stop New Starts Date not transformed");
            Assert.AreEqual(newStartsSuspendedReason, transformedAllocation.allocationTerminationAttrs.newStartsSuspendedReason,
                "New Starts Suspended Reason not transformed");
            Assert.AreEqual(fundingCessationDate, transformedAllocation.allocationTerminationAttrs.fundingCessationDate,
                "Funding Cessation Date not transformed");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_TransformToCorporateSchemaContract_ShouldPopulateFundingCessationDate()
        {
            // 'AEBC1819'
            const string allocationNumber = "AEC-529";
            DateTime fundingCessationDate = DateTime.Now;
            contract corpContract = GetCorporateContractFromFile("corporate_contracts_withAEBC1819.json");

            Assert.IsNotNull(corpContract);
            corpContract.contracts.First().contractAllocations
                .Single(a => a.contractAllocationNumber == allocationNumber).FundingCessationDate = fundingCessationDate;

            ContractTransformer contractTransformer = new ContractTransformer();

            // act
            SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contract schemaContract = contractTransformer.TransformToCorporateSchemaContract(corpContract);

            // assert
            var terminationAllocationAttrs = schemaContract.contracts.First().contractAllocations
                .Single(a => a.contractAllocationNumber == "AEC-529").allocationTerminationAttrs;

           Assert.AreEqual(fundingCessationDate, terminationAllocationAttrs.fundingCessationDate);
        }

        private static contract GetCorporateContractFromFile(string fileName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"ContractManagementDomain.Endpoint.Tests.Resources.{fileName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<contract>(streamReader.ReadToEnd());
            }
        }

        public List<SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractDeliverablesTypeContractDeliverable> FlattenDeliverables(
            List<SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractDeliverablesTypeContractDeliverable> hierarchicalDeliverableList,
            List<SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractDeliverablesTypeContractDeliverable> flattenedList = null,
            int? parentDeliverablId = null)
        {
            flattenedList = flattenedList ?? new List<SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractDeliverablesTypeContractDeliverable>();

            foreach (var deliverable in hierarchicalDeliverableList)
            {
                flattenedList.Add(deliverable);

                flattenedList = FlattenDeliverables(deliverable.contractDeliverables, flattenedList, deliverable.deliverable.deliverableCode);
            }

            return flattenedList;
        }
    }
}

namespace ContractCreateDomain.Tests
{
    using AutoMapper;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using System.Collections.Generic;
    using System.Linq;

    [TestClass]
    public class CollectionTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CollectionTransformer_ShouldTransform()
        {
            // arrange
            const string fundingTypeCode = "FT";
            const string fundingPeriodCode = "FP";
            const string contractType = "CT";

            IReadOnlyCollection<FundingTypeFundingPeriodContractType> models =
                new List<FundingTypeFundingPeriodContractType>
                {
                    new FundingTypeFundingPeriodContractType(fundingTypeCode, fundingPeriodCode, contractType, "")
                };

            // act

            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<FundingTypeFundingPeriodContractType,
                              FundingTypeFundingPeriodContractTypeDto>();
            },null);

            var mapper = config.CreateMapper();

            var dtos = CollectionTransformer.Transform<
                FundingTypeFundingPeriodContractType,
                FundingTypeFundingPeriodContractTypeDto>(
                    models,
                    mapper);


            // assert
            Assert.AreEqual(models.Count, dtos.Count, "The number of transformed objects does not match");
            Assert.AreEqual(models.First().ContractType, dtos.First().ContractType, "The ContractType does not match");
            Assert.AreEqual(models.First().FundingPeriodCode, dtos.First().FundingPeriodCode, "The FundingPeriodCode does not match");
            Assert.AreEqual(models.First().FundingTypeCode, dtos.First().FundingTypeCode, "The FundingTypeCode does not match");
        }
    }
}

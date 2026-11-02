namespace SFA.FCT.FundingPolicyDomain.Controllers
{
    using System;
    using System.Web.Http;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.ExcelUpload;
    using FundingStreamConfigDomain.BusinessLogic;
    using Attributes;

    [RoutePrefix("rest/referencedatalookup")]
    [Authorize]
    [SecureResource]
    public class ReferenceDataLookupApiController : ApiController
    {
        public IReferenceDataManager Manager { get; set; }

        [HttpGet]
        [Route]
        public IHttpActionResult GetLookupData(string period, string periodType, string fundingType)
        {
            try
            {
                FundingConfigurationType result = Manager.GetFundingConfiguration(period, periodType, fundingType);
                return Ok(result);
            }
            catch (Exception ex)
            {
                throw new System.Web.HttpException(400, ex.ToString(), ex);
            }
        }

        [HttpGet]
        [Route]
        public IHttpActionResult GetFscDeliverableData(string fundingStreamPeriod)
        {
            try
            {
                FSCDeliverableStructureDefinitionResponse result =
                    Manager.GetDeliverableConfiguration(fundingStreamPeriod);

                return Ok(result);
            }
            catch (Exception ex)
            {
                throw new System.Web.HttpException(400, ex.ToString(), ex);
            }
        }
    }
}
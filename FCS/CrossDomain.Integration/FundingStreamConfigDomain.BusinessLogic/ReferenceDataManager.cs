namespace SFA.FCT.FundingStreamConfigDomain.BusinessLogic
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.ExcelUpload;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;

    public class ReferenceDataManager : IReferenceDataManager
    {
        ////private readonly OrganizationService _organizationService = OrganisationServiceManager.GetOrgService();
        public IOrganizationService OrganizationService { get; set; }

        public FundingConfigurationType GetFundingConfiguration(string period, string periodType, string fundingType)
        {
            var fc = new FundingConfigurationType();

            using (var xrm = new OrganizationServiceContext(OrganizationService))
            {
                var complexQuery =
                    from ft in xrm.CreateQuery("sfa_fundingtype")
                    join ftfs in xrm.CreateQuery("sfa_fundingtype_fundingstream")
                        on ft["sfa_fundingtypeid"] equals ftfs["sfa_fundingtypeid"]
                    join fs in xrm.CreateQuery("sfa_fundingstream")
                        on ftfs["sfa_fundingstreamid"] equals fs["sfa_fundingstreamid"]
                    join fsp in xrm.CreateQuery("sfa_fundingstreamperiod")
                        on fs["sfa_fundingstreamid"] equals fsp["sfa_fundingstreamcodeid"]
                    join fp in xrm.CreateQuery("sfa_period")
                        on fsp["sfa_periodid"] equals fp["sfa_periodid"]
                    join pt in xrm.CreateQuery("sfa_periodtype")
                        on fp["sfa_periodtypeid"] equals pt["sfa_periodtypeid"]
                    where pt.GetAttributeValue<string>("sfa_periodtypecode") == periodType
                    where fp.GetAttributeValue<string>("sfa_period") == period
                    where ft.GetAttributeValue<string>("sfa_fundingtypecode") == fundingType
                    select new FundingConfigurationDataType()
                    {
                        FundingTypeCode = ft.GetAttributeValue<string>("sfa_fundingtypecode"),

                        // FundingTypeName = ft.GetAttributeValue<string>("sfa_name")
                        FundingStreamCode = fs.GetAttributeValue<string>("sfa_fundingstreamcode"),
                        FundingStreamId = fs.GetAttributeValue<Guid>("sfa_fundingstreamid").ToString(),
                        FundingStreamName = fs.GetAttributeValue<string>("sfa_fundingstreamname"),
                        FundingStreamShortCode = fs.GetAttributeValue<string>("sfa_fundingstreamshortcode"),

                        FundingStreamCodeId = fs.GetAttributeValue<Guid>("sfa_fundingstreamid").ToString(), // duplicate
                        FundingStreamPeriodCode = fsp.GetAttributeValue<string>("sfa_fundingstreamperiodcode"),

                        Period = fp.GetAttributeValue<string>("sfa_period"),
                        FundingPeriodStartDate = fp.GetAttributeValue<DateTime>("sfa_startdate"),
                        FundingPeriodEndDate = fp.GetAttributeValue<DateTime>("sfa_enddate"),

                        PeriodTypeCode = pt.GetAttributeValue<string>("sfa_periodtypecode"),
                        PeriodTypeName = pt.GetAttributeValue<string>("sfa_periodtypename"),
                    };

                fc.FundingConfigurationList = complexQuery.ToArray();
            }

            return fc;
        }
    }
}
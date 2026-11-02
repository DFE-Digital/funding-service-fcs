namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmClaimReconciliationPublicationExceptionWriter : CrmConfigWriter<ClaimReconciliationPublicationExceptionSheetType, sfa_claimreconciliationpublicationexception>
    {
        protected override void UpdateMatchingEntity(ClaimReconciliationPublicationExceptionSheetType row, sfa_claimreconciliationpublicationexception matchingEntity)
        {
            //This entity can't be updated because its unique identifiers are the only properties that can be changed.
        }

        protected override sfa_claimreconciliationpublicationexception CreateEntity(ClaimReconciliationPublicationExceptionSheetType row)
        {
            using (var serviceContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                sfa_claimreconallocgroup claimReconciliationAllocationGroup = GetClaimReconciliationAllocationGroupByCode(serviceContext, row.ClaimReconciliationAllocationGroupCode);
                Account crmOrganisation = GetCrmOrganisationByUkprn(serviceContext, row.Ukprn.ToString());

                sfa_claimreconciliationpublicationexception createdEntity = new sfa_claimreconciliationpublicationexception
                {
                    sfa_ukprn = row.Ukprn.ToString(),
                    sfa_claimreconciliationallocationgroup = claimReconciliationAllocationGroup.ToEntityReference(),
                    sfa_name = GetSfaName(row),
                    sfa_provider = crmOrganisation?.ToEntityReference()
                };

                return createdEntity;
            }
        }

        protected override IEnumerable<sfa_claimreconciliationpublicationexception> GetMatchingEntities(XrmServiceContext crmContext, ClaimReconciliationPublicationExceptionSheetType row)
        {
            sfa_claimreconallocgroup claimReconciliationAllocationGroupForGivenRow = GetClaimReconciliationAllocationGroupByCode(crmContext, row.ClaimReconciliationAllocationGroupCode);
            return
                crmContext.sfa_claimreconciliationpublicationexceptionSet
                    .Where(crpe => crpe.sfa_ukprn == row.Ukprn.ToString())
                    .Where(crpe => crpe.sfa_claimreconciliationallocationgroup.Id == claimReconciliationAllocationGroupForGivenRow.ToEntityReference().Id);
        }

        private static sfa_claimreconallocgroup GetClaimReconciliationAllocationGroupByCode(XrmServiceContext crmContext, string claimAllocationReconciliationGroupCode)
        {
            return crmContext.sfa_claimreconallocgroupSet
                    .Single(c => c.sfa_AllocationGroupCode == claimAllocationReconciliationGroupCode);
        }

        private static Account GetCrmOrganisationByUkprn(XrmServiceContext crmContext, string ukprn)
        {
            return crmContext.AccountSet.SingleOrDefault(o => o.sfa_UKPRN == ukprn);
        }

        private static string GetSfaName(ClaimReconciliationPublicationExceptionSheetType sheet)
        {
            return $"{sheet.ClaimReconciliationAllocationGroupCode}_{sheet.Ukprn}";
        }
    }
}

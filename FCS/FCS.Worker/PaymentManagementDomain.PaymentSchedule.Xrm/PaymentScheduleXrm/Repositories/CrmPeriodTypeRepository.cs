namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmPeriodTypeRepository : ICrmPeriodTypeRepository
    {
        public readonly IOrganizationService _organisationService;
        private static EntityReference _calendarMontthPeriodType = null;

        public CrmPeriodTypeRepository(IOrganizationService organisationService)
        {
            _organisationService = organisationService;
        }

        public EntityReference GetCalendarMonthPeriodType()
        {
            if (_calendarMontthPeriodType == null)
            {
                _calendarMontthPeriodType = new EntityReference(sfa_periodtype.EntityLogicalName, GetValueFromCrm());
            }

            return _calendarMontthPeriodType;
        }

        private Guid GetValueFromCrm()
        {
            const string periodTypeCodeCalendarMonth = "CM";

            using (var xrmContext = new XrmServiceContext(_organisationService))
            {
                return xrmContext.sfa_periodtypeSet
                    .Where(p => p.sfa_periodtypecode == periodTypeCodeCalendarMonth)
                    .Select(pt => pt.Id)
                    .Single();
            }
        }
    }
}

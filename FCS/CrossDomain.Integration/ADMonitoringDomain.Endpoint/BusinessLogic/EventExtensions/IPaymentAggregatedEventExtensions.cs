using ADMonitoringDomain.DataStore.Model;
using SFA.FCT.CrossDomain.Integration.Common;
using SFA.FCT.CrossDomain.Integration.Events;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ADMonitoringDomain.Endpoint.BusinessLogic.EventExtensions
{
    public static class IPaymentAggregatedEventExtensions
    {
        public static AllocationDeliveryEventReceived ToAllocationDeliveryEventReceived(this IPaymentAggregatedEvent pae,IDate dateService,string category="")
        {
            return new AllocationDeliveryEventReceived()
            {
                AllocationNumber = pae.Allocation.AllocationNumber,
                VersionNumber = pae.Allocation.VersionNumber,
                EventName = pae.GetType().Name,
                CategoryName = category,
                EventReceived = dateService.GetCalculationDate(),
                Object = pae,
                ObjectType = pae.GetType().AssemblyQualifiedName
            };
        }
    }
}

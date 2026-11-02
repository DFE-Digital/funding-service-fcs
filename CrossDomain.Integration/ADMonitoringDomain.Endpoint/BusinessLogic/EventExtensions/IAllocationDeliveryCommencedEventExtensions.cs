using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ADMonitoringDomain.DataStore.Model;
using SFA.FCT.CrossDomain.Integration.Common;
using SFA.FCT.CrossDomain.Integration.Events;

namespace ADMonitoringDomain.Endpoint.BusinessLogic.EventExtensions
{
    public static class IAllocationDeliveryCommencedEventExtensions
    {
        public static AllocationDeliveryEventReceived ToAllocationDeliveryEventReceived(this IAllocationDeliveryCommencedEvent adce, IDate dateService, string category = "")
        {
            return new AllocationDeliveryEventReceived()
            {
                AllocationNumber = adce.Allocation.contractAllocationNumber,
                CategoryName = category,
                EventName = adce.GetType().Name,
                EventReceived = dateService.GetCalculationDate(),
                VersionNumber = adce.Allocation.contractReference.contractVersionNumber,
                Object = adce,
                ObjectType = adce.GetType().AssemblyQualifiedName
            };
        }
    }
}

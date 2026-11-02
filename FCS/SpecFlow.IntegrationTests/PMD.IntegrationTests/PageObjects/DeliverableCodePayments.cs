using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PMD.IntegrationTests.PageObjects
{
    public class DeliverableCodePayments
    {
        public DeliverableCodePayments()
        {
            Payments = new List<DeliverablePayment>();
        }

        public  List<DeliverablePayment> Payments { get; set; }

        public int DeliverableCode { get; set; }

        public int? ParentDeliverableCode { get; set; }
    }
}

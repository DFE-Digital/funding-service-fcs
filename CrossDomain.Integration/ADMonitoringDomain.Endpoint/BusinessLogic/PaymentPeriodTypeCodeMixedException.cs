using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    public class PaymentPeriodTypeCodeMixedException :Exception
    {

        public PaymentPeriodTypeCodeMixedException()
        {
        }

        public PaymentPeriodTypeCodeMixedException(string message) : base(message)
        {
        }

        public PaymentPeriodTypeCodeMixedException(string message, Exception inner)
            : base(message, inner)
        {
        }


    }
}

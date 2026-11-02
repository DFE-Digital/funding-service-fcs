using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Operations.Web.Dtos;

namespace Operations.Web.Repositories
{
    public interface IPaymentBFItemQueryRepository
    {
        Task<IReadOnlyCollection<PaymentBatchFeedInfo>> GetItemByFundingStreamPeriod(string fundingStreamPeriod);
        Task<string> GetXmlForContract(int id);
    }
}

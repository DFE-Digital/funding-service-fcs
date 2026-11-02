using ContractManagement.DataStore;
using Operations.Web.Dtos;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity;
using System.Data.SqlClient;
using System.IO.Compression;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Threading.Tasks;
using System.Web;
using Operations.Web.PaymentGenerationDataStore;

namespace Operations.Web.Repositories
{
    public class PaymentBFItemQueryRepository : IPaymentBFItemQueryRepository
    {
        private static string ConnectionString => ConfigurationManager
            .ConnectionStrings["PaymentGenDBContext"].ConnectionString;

        public async Task<IReadOnlyCollection<PaymentBatchFeedInfo>> GetItemByFundingStreamPeriod(string fundingStreamPeriod)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new PaymentGenDBContext())
                {
                    var rows = await context.PaymentBatchFeedItems.ToListAsync();
                    var result = rows
                        .Where(x => x.FundingStreamPeriod == fundingStreamPeriod)
                        .OrderBy(x => x.Id)
                        .Select(x => new PaymentBatchFeedInfo
                        {
                            Id = x.Id,
                            FundingStreamPeriod = x.FundingStreamPeriod,
                            PaymentPeriod = x.PaymentPeriod,
                            CensusEndDate = x.CensusEndDate,
                            CreatedDate = x.CreatedDate
                        });
                    return result.ToList();
                }
            }
        }


        public async Task<string> GetXmlForContract(int id)
        {
            using (var context = new PaymentGenDBContext())
            {
                var result = await (from res in context.PaymentBatchFeedItems.Where(p => p.Id == id) select res.CorporatePaymentBatchBytes).FirstAsync();
                return ToStringFromZippedBytes(result);
            }
        }

        private static string ToStringFromZippedBytes(byte[] bytes)
        {
            using (GZipStream bigStream = new GZipStream(new MemoryStream(bytes), CompressionMode.Decompress))
            {
                MemoryStream bigStreamOut = new MemoryStream();
                bigStream.CopyTo(bigStreamOut);
                var unZippedBytes = bigStreamOut.ToArray();

                MemoryStream memorystream = new MemoryStream(unZippedBytes);
                BinaryFormatter binaryFormatter = new BinaryFormatter();

                return (string)binaryFormatter.Deserialize(memorystream);
            }
        }
    }
}
using Datafix.Tests.Infrastructure;
using PaymentGenerationDomain.Integration.DataStore;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R140
{
    public class UpdatePostedAndIsSelectPaymentFlag : IApplyDataFix
    {
        public string Release => "R140";
        public int StoryNumber => 38856;
        public string Name => "Update PostedFlag And IsSelectedForPayment Flag";
        public int Order => 1;

        public void ApplyDataFix()
        { 
            using (var context = new PaymentGenerationDbContext())
            {
                const string sqlFeedRead = @"UPDATE [PaymentGeneration].[SubnominalAggregation]
                                            SET [IsSelectedForPayment] = '1' , [PostedFlag] = '1' 
                                            WHERE [period] = '202301' 
                                            AND [AggregatedValue] <> 0 
                                            AND AllocationNumber IN (
                                                'APPS-3323',
                                                'APPS-3341',
                                                'APPS-3372',
                                                'APPS-3420',
                                                'APPS-3424',
                                                'APPS-3447',
                                                'APPS-3449',
                                                'APPS-3457',
                                                'APPS-3459',
                                                'APPS-3466',
                                                'APPS-3475',
                                                'APPS-3479',
                                                'APPS-3487',
                                                'APPS-3502',
                                                'APPS-3504',
                                                'APPS-3511',
                                                'APPS-3520',
                                                'APPS-3535',
                                                'APPS-3539',
                                                'APPS-3541',
                                                'APPS-3553',
                                                'APPS-3556',
                                                'APPS-3307',
                                                'APPS-3299',
                                                'APPS-3301',
                                                'APPS-3315',
                                                'APPS-3355',
                                                'APPS-3356',
                                                'APPS-3360',
                                                'APPS-3361',
                                                'APPS-3363',
                                                'APPS-3366',
                                                'APPS-3371',
                                                'APPS-3406',
                                                'APPS-3434',
                                                'APPS-3450',
                                                'APPS-3489',
                                                'APPS-3496',
                                                'APPS-3545'
                                                )";
                 
                var data = context.Database.ExecuteSqlCommand(sqlFeedRead);
            }
        }
    }
}

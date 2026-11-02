namespace FCT.Operations.FundingConfirmationReport.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DTOs;
    using Extensions;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class LAReportService : IlaReportService
    {
        private readonly ILAFundingConfirmationReportRepository _reportRepository;

        public LAReportService(ILAFundingConfirmationReportRepository reportRepository)
        {
            _reportRepository = reportRepository;
        }

        public async Task<IReadOnlyCollection<ReportRow>> GetLAReportRows(Period period, ConnectionInfo connectionInfo)
        {
            var ukpnInfos = await _reportRepository.GetLAUkprnsForPeriod(period.GetFinancialYearStart(),
                period.GetFinancialYearEnd(), connectionInfo);
            var ukprns = ukpnInfos.Select(u => u.Ukprn).ToList();
            var fspInfos = await _reportRepository.GetLAFspInfos(ukprns,
                 period.GetFinancialYearStart(),
                period.GetFinancialYearEnd(), connectionInfo);


            var fspsPoP = fspInfos.Where(f => f.PaymentMethod == PaymentMethod.PayOnProfile).Select(f => f.FspCode).ToList();
            var fspsPoAFinancialYear = fspInfos.Where(f => f.PaymentMethod == PaymentMethod.PayOnActuals && f.IsAcademicYear).Select(f => f.FspCode).ToList();
            var fspsPoAForALAPNLAP = fspInfos.Where(f => f.PaymentMethod == PaymentMethod.PayOnActuals && !f.IsAcademicYear).Select(f => f.FspCode).ToList();
            var fspsPayOnInstruction = fspInfos.Where(f => f.PaymentMethod == PaymentMethod.PayOnInstruction).Select(f => f.FspCode).ToList();

            var paymentInfosPop = await _reportRepository.GetLADeliverablePaymentInfosForPoP(ukprns, fspsPoP, period.GetFinancialYearStart(),
                period.GetFinancialYearEnd(), connectionInfo);
            var paymentInfosPoAForFY = await _reportRepository.GetLADeliverablePaymentInfosForPoAForFinancialYear(ukprns, fspsPoAFinancialYear, period.GetFinancialYearStart(),
                period.GetFinancialYearEnd(), connectionInfo);
            var paymentInfosPoAForALAPNLAP = await _reportRepository.GetLADeliverablePaymentInfosForPoAForALAPNLAP(ukprns, fspsPoAForALAPNLAP, period.GetFinancialYearStart(),
                period.GetFinancialYearEnd(), connectionInfo);
            var netPaymentInfosForPayOnInstruction = await _reportRepository.GetLANetPaymentInfosForPayOnInstruction(
                ukprns,
                fspsPayOnInstruction,
                period.GetFinancialYearStart(),
                period.GetFinancialYearEnd(),
                connectionInfo);

            var paymentInfoLookupPop = paymentInfosPop.ToLookup(pi => pi.Ukprn);
            var paymentInfoLookupPoAForFY = paymentInfosPoAForFY.ToLookup(pi => pi.Ukprn);
            var paymentInfoLookupPoAForALAPNLAP = paymentInfosPoAForALAPNLAP.ToLookup(pi => pi.Ukprn);
            var netPaymentInfoLookupForPoI = netPaymentInfosForPayOnInstruction.ToLookup(pi => pi.Ukprn);
            var fspDictionary = fspInfos.ToDictionary(f => f.FspCode);

            return ukpnInfos.Select(u =>
            {
                var paymentInfoForUkprnPoP = paymentInfoLookupPop[u.Ukprn.ToString()];
                var paymentInfoForUkprnPoAForFY = paymentInfoLookupPoAForFY[u.Ukprn.ToString()];
                var paymentInfoForUkprnPoAForALAPNLAP = paymentInfoLookupPoAForALAPNLAP[u.Ukprn.ToString()];
                var netPaymentForUkprnPoI = netPaymentInfoLookupForPoI[u.Ukprn.ToString()];

                var fspPaymentInfosPop =
                    paymentInfoForUkprnPoP.ToFspAllocationAndFundedItems(fspCode => fspDictionary[fspCode], PaymentMethod.PayOnProfile);

                var fspPaymentInfosPoAForFY =
                    paymentInfoForUkprnPoAForFY.ToFspAllocationAndFundedItems(fspCode => fspDictionary[fspCode], PaymentMethod.PayOnActuals);

                var fspPaymentInfosPoAForALAPNLAP =
                    paymentInfoForUkprnPoAForALAPNLAP.ToFspAllocationAndFundedItems(fspCode => fspDictionary[fspCode], PaymentMethod.PayOnActuals);

                var fspPaymentInfosPoI =
                    netPaymentForUkprnPoI.ToFspAllocationAndFundedItems(fspCode => fspDictionary[fspCode], PaymentMethod.PayOnInstruction);

                var fspPaymentValues = fspPaymentInfosPoAForFY
                    .Concat(fspPaymentInfosPop)
                    .Concat(fspPaymentInfosPoAForALAPNLAP)
                    .Concat(fspPaymentInfosPoI)
                    .OrderBy(p => p.Order).ToList();

                return new ReportRow(u.Ukprn, u.Name, u.Type, fspPaymentValues);
            }).ToList();
        }
   
        private class FspAndUkprn
        {
            public FspAndUkprn(string fspCode, string ukprn)
            {
                FspCode = fspCode;
                Ukprn = ukprn;
            }

            private string FspCode { get; }
            private string Ukprn { get; }

            public override int GetHashCode()
            {
                return FspCode.GetHashCode() ^ Ukprn.GetHashCode();
            }

            public override bool Equals(object obj)
            {
                if (obj is FspAndUkprn other)
                {
                    return FspCode == other.FspCode &&
                           Ukprn == other.Ukprn;
                }

                return false;
            }
        }
    }
}

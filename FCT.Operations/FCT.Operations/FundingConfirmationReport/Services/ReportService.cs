namespace FCT.Operations.FundingConfirmationReport.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DTOs;
    using Extensions;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System;
    using Microsoft.AspNetCore.Server.IIS.Core;
    using System.Security.Cryptography.Xml;

    public class ReportService : IReportService
    {
        private readonly IFundingConfirmationReportRepository _reportRepository;

        public ReportService(IFundingConfirmationReportRepository reportRepository)
        {
            _reportRepository = reportRepository;
        }

        public async Task<IReadOnlyCollection<ReportRow>> GetReportRows(Period period, ConnectionInfo connectionInfo)
        {
            var ukpnInfos = await _reportRepository.GetUkprnsForPeriod(period.GetAcademicYearStart(),
                period.GetAcademicYearEnd(), connectionInfo);

            var ukprns = ukpnInfos.Select(u => u.Ukprn).ToList();
            //var fundingPeriods = await _reportRepository.GetFundingPeriodsForPeriod(period, connectionInfo);
            var fspInfos = await _reportRepository.GetFspInfos(ukprns,period.GetAcademicYearStart(),
                period.GetAcademicYearEnd(), connectionInfo);
           
            var fspsPoP = fspInfos.Where(f => f.PaymentMethod == PaymentMethod.PayOnProfile).Select(f => f.FspCode).ToList();
            var fspsPoAAcademicYear = fspInfos.Where(f => f.PaymentMethod == PaymentMethod.PayOnActuals && !f.IsProcuredFSP).Select(f => f.FspCode).ToList();
            var fspsPoANonAcademicYear = fspInfos.Where(f => f.PaymentMethod == PaymentMethod.PayOnActuals && f.IsProcuredFSP).Select(f => f.FspCode).ToList();
            var fspsPayOnInstruction = fspInfos.Where(f => f.PaymentMethod == PaymentMethod.PayOnInstruction).Select(f => f.FspCode).ToList();

            var paymentInfosPop = await _reportRepository.GetDeliverablePaymentInfosForPoP(
                fspsPoP,
                period.GetAcademicYearStart(),
                period.GetAcademicYearEnd(), 
                connectionInfo);
            var paymentInfosPoAForAY = await _reportRepository.GetDeliverablePaymentInfosForPoAForAcademicYear(
                fspsPoAAcademicYear,
                period.GetAcademicYearStart(),
                period.GetAcademicYearEnd(), 
                connectionInfo);
            var paymentInfosPoAForNonAY = await GetDeliverablePaymentsForPoANonAcademicYear(fspsPoANonAcademicYear,period, connectionInfo);
            var netPaymentInfosForPayOnInstruction = await _reportRepository.GetNetPaymentInfosForPayOnInstruction(                
                fspsPayOnInstruction,
                period.GetAcademicYearStart(),
                period.GetAcademicYearEnd(),
                connectionInfo);

            var paymentInfoLookupPop = paymentInfosPop.ToLookup(pi => pi.Ukprn);
            var paymentInfoLookupPoAForAY = paymentInfosPoAForAY.ToLookup(pi => pi.Ukprn);
            var paymentInfoLookupPoAForNonAY = paymentInfosPoAForNonAY.ToLookup(pi => pi.Ukprn);
            var netPaymentInfoLookupForPoI = netPaymentInfosForPayOnInstruction.ToLookup(pi => pi.Ukprn);
            var fspDictionary = fspInfos.ToDictionary(f => f.FspCode);

            return ukpnInfos.Select(u =>
            {
                var paymentInfoForUkprnPoP = paymentInfoLookupPop[u.Ukprn.ToString()];
                var paymentInfoForUkprnPoAForAY = paymentInfoLookupPoAForAY[u.Ukprn.ToString()];
                var paymentInfoForUkprnPoAForNonAY = paymentInfoLookupPoAForNonAY[u.Ukprn.ToString()];
                var netPaymentForUkprnPoI = netPaymentInfoLookupForPoI[u.Ukprn.ToString()];

                var fspPaymentInfosPop =
                    paymentInfoForUkprnPoP.ToFspAllocationAndFundedItems(fspCode => fspDictionary[fspCode], PaymentMethod.PayOnProfile);

                var fspPaymentInfosPoAForAY =
                    paymentInfoForUkprnPoAForAY.ToFspAllocationAndFundedItems(fspCode => fspDictionary[fspCode], PaymentMethod.PayOnActuals);

                var fspPaymentInfosPoAForNonAY =
                    paymentInfoForUkprnPoAForNonAY.ToFspAllocationAndFundedItems(fspCode => fspDictionary[fspCode], PaymentMethod.PayOnActuals);

                var fspPaymentInfosPoI =
                    netPaymentForUkprnPoI.ToFspAllocationAndFundedItems(fspCode => fspDictionary[fspCode], PaymentMethod.PayOnInstruction);

                var fspPaymentValues = fspPaymentInfosPoAForAY
                    .Concat(fspPaymentInfosPop)
                    .Concat(fspPaymentInfosPoAForNonAY)
                    .Concat(fspPaymentInfosPoI)
                    .OrderBy(p => p.Order).ToList();

                return new ReportRow(u.Ukprn, u.Name, u.Type, fspPaymentValues);
            }).ToList();
        }


        private async Task<IReadOnlyCollection<DeliverablePaymentInfo>> GetDeliverablePaymentsForPoANonAcademicYear(IReadOnlyCollection<string> fspsPoANonAcademicYear, Period period, ConnectionInfo connectionInfo)
        {
            try
            {

                var paymentInfosPoAForNonAY = await _reportRepository.GetDeliverablePaymentInfosForPoAForNonAcademicYear(
                    fspsPoANonAcademicYear,
                    period.GetAcademicYearStart(),
                    period.GetAcademicYearEnd(),
                    connectionInfo);

                var paymentInfosPoAForNonAyfInfosForPoAForFinancialYear = await _reportRepository.GetDeliverablePaymentInfosForPoAForNonAcademicYear(
                    fspsPoANonAcademicYear,
                    period.GetFinancialYearStart(),
                    period.GetFinancialYearEnd(),
                    connectionInfo);

                var financialYearPaymentDictionary =
                    paymentInfosPoAForNonAyfInfosForPoAForFinancialYear.ToDictionary(p => new FspAndUkprn(p.FspCode, p.Ukprn));

                return paymentInfosPoAForNonAY.Select(p =>
                {
                    decimal valueB;

                    if (p.Ukprn == "10094574")
                    {

                        if (p.FspCode == "16-18NLAP2018" || p.FspCode == "ANLAP2018")
                        {
                            return new DeliverablePaymentInfo(p.ValueA, p.ValueA, p.Ukprn, p.FspCode);
                        }
                    }
                    var financialYearVal = financialYearPaymentDictionary[new FspAndUkprn(p.FspCode, p.Ukprn)];
                    var finacialYearActuals = financialYearVal.ValueA;
                    var finacialYearPlanned = financialYearVal.ValueB;
                    if (finacialYearActuals <= finacialYearPlanned)
                    {
                        valueB = p.ValueA;
                    }
                    else
                    {
                        valueB = p.ValueA - (finacialYearActuals - finacialYearPlanned);
                    }

                    return new DeliverablePaymentInfo(p.ValueA, valueB, p.Ukprn, p.FspCode);
                }).ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }

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

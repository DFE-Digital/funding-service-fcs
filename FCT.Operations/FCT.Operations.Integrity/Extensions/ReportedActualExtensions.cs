namespace SFA.FCT.Operations.Integrity.Extensions
{
    using AllocationDeliveryDomain.Common.Storage;
    using AutoMapper;
    using Microsoft.Extensions.Logging;

    public static class ReportedActualExtensions
    {
        private static IMapper _mapper;

        public static EnrichedReportedActual ToEnrichedReportedActualFromReportedActual(this ReportedActual reportedActual)
        {
            return GetMapper().Map<EnrichedReportedActual>(reportedActual);
        }


        private static IMapper GetMapper()
        {
            if (_mapper == null)
            {
                var loggerFactory = LoggerFactory.Create(builder => { });

                var config = new MapperConfiguration(cfg =>
                {
                    cfg.CreateMap<ReportedActual, EnrichedReportedActual>();
                }, loggerFactory);

                _mapper = config.CreateMapper();
            }

            return _mapper;
        }

    }
}

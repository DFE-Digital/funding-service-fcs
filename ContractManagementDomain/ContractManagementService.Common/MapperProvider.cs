
using System;
using AutoMapper;
using AutoMapper.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;

namespace SFA.FCT.ContractManagementService.Common
{
    public static class MapperProvider
    {
        private static readonly Lazy<IMapper> _instance = new Lazy<IMapper>(() =>
        {            
            var expr = new MapperConfigurationExpression();
            expr.AddProfile<ContractMappingProfile>();
            ILoggerFactory loggerFactory = NullLoggerFactory.Instance;
            var config = new MapperConfiguration(expr, loggerFactory);
            config.AssertConfigurationIsValid();
            return config.CreateMapper();
        });

        public static IMapper Instance => _instance.Value;
    }
}


namespace FCT.Console.Config.Transformers
{
    using System;
    using AutoMapper;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class PaymentTypeResolver
        : IValueResolver<object, object, PaymentType?>
    {
        public PaymentType? Resolve(
            object source,
            object destination,
            PaymentType? destMember,
            ResolutionContext context)
        {
            var sourceValue = source as string;

            if (sourceValue != null)
            {
                return (PaymentType)
                    Enum.Parse(
                        typeof(PaymentType),
                        TransformSheetValue(sourceValue),
                        ignoreCase: true);
            }

            return null;
        }

        private string TransformSheetValue(string source)
        {
            return source.Replace(" ", string.Empty);
        }
    }
}

namespace FCT.Operations.Cda.Infrastructure.Csv.Attributes
{
    using System;

    public class OrderAttribute : Attribute
    {
        public OrderAttribute(int order)
        {
            Order = order;
        }

        public int Order { get; }
    }
}

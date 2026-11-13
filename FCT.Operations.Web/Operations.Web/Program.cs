using CoreWCF.Configuration;
using CoreWCF.Description;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Builder;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddServiceModelServices();
builder.Services.AddServiceModelMetadata();
builder.Services.AddSingleton<IServiceBehavior, UseRequestHeadersForMetadataAddressBehavior>();

var app = builder.Build();

app.Use(async (context, next) =>
{
    await next();
    context.Response.Headers.Remove("Server");
});

app.MapControllers();

app.UseServiceModel(serviceBuilder =>
{
    // Add CoreWCF endpoints here
});

var serviceMetadataBehavior =
    app.Services.GetRequiredService<ServiceMetadataBehavior>();

serviceMetadataBehavior.HttpGetEnabled = true;

app.Run();
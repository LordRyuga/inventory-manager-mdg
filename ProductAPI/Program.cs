using ProductAPI.Data;
using ProductAPI.Repositories;
using ProductAPI.services;
using Microsoft.EntityFrameworkCore;
using ProductAPI.Models;
using ProductAPI.Repositories.impl;
using ProductAPI.services.InventoryManagement.Services;
using DotNetEnv;

Env.Load();

var db_pass = Environment.GetEnvironmentVariable("DB_PASSWORD");

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Database
builder.Services.AddDbContext<InventoryContext>(options =>
{
    var connectionString = $"Host=aws-0-ap-south-1.pooler.supabase.com;Port=6543;Database=postgres;Username=postgres.ulydouacivuvupzjwpkt;Password={db_pass};SSL Mode=Require;Trust Server Certificate=true;Timeout=30;CommandTimeout=60;";
    options.UseNpgsql(connectionString);
});
// Repository pattern
builder.Services.AddScoped<IProductRepository, ProductRepository>();

// Business logic services
builder.Services.AddScoped<IProductService, ProductService>();

// CORS for Flutter app
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutter", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowFlutter");
app.UseAuthorization();
app.MapControllers();

app.Urls.Add("http://0.0.0.0:80");

app.Run();

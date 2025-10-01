using System;
using System.Collections.Generic;
using CompteDepot.Models;
using Microsoft.EntityFrameworkCore;
using Pomelo.EntityFrameworkCore.MySql.Scaffolding.Internal;

namespace CompteDepot.Data;

public partial class ApplicationDbContext : DbContext
{
    public ApplicationDbContext()
    {
    }

    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Client> Clients { get; set; }

    public virtual DbSet<Compte> Comptes { get; set; }

    public virtual DbSet<Historiquesolde> Historiquesoldes { get; set; }

    public virtual DbSet<Operation> Operations { get; set; }

    public virtual DbSet<Personne> Personnes { get; set; }

    public virtual DbSet<Pret> Prets { get; set; }

    public virtual DbSet<Remboursement> Remboursements { get; set; }

    public virtual DbSet<Taux> Tauxes { get; set; }

    public virtual DbSet<Typecompte> Typecomptes { get; set; }

    public virtual DbSet<Typeoperation> Typeoperations { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseMySql("server=localhost;database=situationbanque;user=root", Microsoft.EntityFrameworkCore.ServerVersion.Parse("10.4.32-mariadb"));

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder
            .UseCollation("utf8mb4_general_ci")
            .HasCharSet("utf8mb4");

        modelBuilder.Entity<Client>(entity =>
        {
            entity.HasKey(e => e.IdClient).HasName("PRIMARY");

            entity.ToTable("client");

            entity.HasIndex(e => e.IdPersonne, "idPersonne");

            entity.HasIndex(e => e.NumeroClient, "numeroClient").IsUnique();

            entity.Property(e => e.IdClient)
                .HasColumnType("int(11)")
                .HasColumnName("idClient");
            entity.Property(e => e.IdPersonne)
                .HasColumnType("int(11)")
                .HasColumnName("idPersonne");
            entity.Property(e => e.NumeroClient)
                .HasMaxLength(20)
                .HasColumnName("numeroClient");

            entity.HasOne(d => d.IdPersonneNavigation).WithMany(p => p.Clients)
                .HasForeignKey(d => d.IdPersonne)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("client_ibfk_1");
        });

        modelBuilder.Entity<Compte>(entity =>
        {
            entity.HasKey(e => e.IdCompte).HasName("PRIMARY");

            entity.ToTable("compte");

            entity.HasIndex(e => e.IdClient, "idClient");

            entity.HasIndex(e => e.IdTypeCompte, "idTypeCompte");

            entity.HasIndex(e => e.NumeroCompte, "numeroCompte").IsUnique();

            entity.Property(e => e.IdCompte)
                .HasColumnType("int(11)")
                .HasColumnName("idCompte");
            entity.Property(e => e.DateOuverture).HasColumnName("dateOuverture");
            entity.Property(e => e.IdClient)
                .HasColumnType("int(11)")
                .HasColumnName("idClient");
            entity.Property(e => e.IdTypeCompte)
                .HasColumnType("int(11)")
                .HasColumnName("idTypeCompte");
            entity.Property(e => e.NumeroCompte)
                .HasMaxLength(20)
                .HasColumnName("numeroCompte");

            entity.HasOne(d => d.IdClientNavigation).WithMany(p => p.Comptes)
                .HasForeignKey(d => d.IdClient)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("compte_ibfk_1");

            entity.HasOne(d => d.IdTypeCompteNavigation).WithMany(p => p.Comptes)
                .HasForeignKey(d => d.IdTypeCompte)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("compte_ibfk_2");
        });

        modelBuilder.Entity<Historiquesolde>(entity =>
        {
            entity.HasKey(e => e.IdHistorique).HasName("PRIMARY");

            entity.ToTable("historiquesolde");

            entity.HasIndex(e => e.IdCompte, "idCompte");

            entity.Property(e => e.IdHistorique)
                .HasColumnType("int(11)")
                .HasColumnName("idHistorique");
            entity.Property(e => e.DateChangement).HasColumnName("dateChangement");
            entity.Property(e => e.IdCompte)
                .HasColumnType("int(11)")
                .HasColumnName("idCompte");
            entity.Property(e => e.Solde)
                .HasPrecision(15, 2)
                .HasColumnName("solde");

            entity.HasOne(d => d.IdCompteNavigation).WithMany(p => p.Historiquesoldes)
                .HasForeignKey(d => d.IdCompte)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("historiquesolde_ibfk_1");
        });

        modelBuilder.Entity<Operation>(entity =>
        {
            entity.HasKey(e => e.IdOperation).HasName("PRIMARY");

            entity.ToTable("operation");

            entity.HasIndex(e => e.IdCompte, "idCompte");

            entity.HasIndex(e => e.IdTypeOperation, "idTypeOperation");

            entity.Property(e => e.IdOperation)
                .HasColumnType("int(11)")
                .HasColumnName("idOperation");
            entity.Property(e => e.DateOperation).HasColumnName("dateOperation");
            entity.Property(e => e.IdCompte)
                .HasColumnType("int(11)")
                .HasColumnName("idCompte");
            entity.Property(e => e.IdTypeOperation)
                .HasColumnType("int(11)")
                .HasColumnName("idTypeOperation");
            entity.Property(e => e.Montant)
                .HasPrecision(15, 2)
                .HasColumnName("montant");

            entity.HasOne(d => d.IdCompteNavigation).WithMany(p => p.Operations)
                .HasForeignKey(d => d.IdCompte)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("operation_ibfk_2");

            entity.HasOne(d => d.IdTypeOperationNavigation).WithMany(p => p.Operations)
                .HasForeignKey(d => d.IdTypeOperation)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("operation_ibfk_1");
        });

        modelBuilder.Entity<Personne>(entity =>
        {
            entity.HasKey(e => e.IdPersonne).HasName("PRIMARY");

            entity.ToTable("personne");

            entity.HasIndex(e => e.Cin, "CIN").IsUnique();

            entity.Property(e => e.IdPersonne)
                .HasColumnType("int(11)")
                .HasColumnName("idPersonne");
            entity.Property(e => e.Adresse).HasMaxLength(100);
            entity.Property(e => e.Cin)
                .HasMaxLength(20)
                .HasColumnName("CIN");
            entity.Property(e => e.Coordonnees).HasMaxLength(100);
            entity.Property(e => e.Nom).HasMaxLength(50);
            entity.Property(e => e.Prenom).HasMaxLength(50);
        });

        modelBuilder.Entity<Pret>(entity =>
        {
            entity.HasKey(e => e.IdPret).HasName("PRIMARY");

            entity.ToTable("pret");

            entity.HasIndex(e => e.IdCompte, "idCompte");

            entity.Property(e => e.IdPret)
                .HasColumnType("int(11)")
                .HasColumnName("idPret");
            entity.Property(e => e.DatePret).HasColumnName("datePret");
            entity.Property(e => e.DureeMois)
                .HasColumnType("int(11)")
                .HasColumnName("dureeMois");
            entity.Property(e => e.IdCompte)
                .HasColumnType("int(11)")
                .HasColumnName("idCompte");
            entity.Property(e => e.Montant)
                .HasPrecision(15, 2)
                .HasColumnName("montant");

            entity.HasOne(d => d.IdCompteNavigation).WithMany(p => p.Prets)
                .HasForeignKey(d => d.IdCompte)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("pret_ibfk_1");
        });

        modelBuilder.Entity<Remboursement>(entity =>
        {
            entity.HasKey(e => e.IdRemboursement).HasName("PRIMARY");

            entity.ToTable("remboursement");

            entity.HasIndex(e => e.IdPret, "idPret");

            entity.Property(e => e.IdRemboursement)
                .HasColumnType("int(11)")
                .HasColumnName("idRemboursement");
            entity.Property(e => e.DateRemboursement).HasColumnName("dateRemboursement");
            entity.Property(e => e.IdPret)
                .HasColumnType("int(11)")
                .HasColumnName("idPret");
            entity.Property(e => e.Montant)
                .HasPrecision(15, 2)
                .HasColumnName("montant");

            entity.HasOne(d => d.IdPretNavigation).WithMany(p => p.Remboursements)
                .HasForeignKey(d => d.IdPret)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("remboursement_ibfk_1");
        });

        modelBuilder.Entity<Taux>(entity =>
        {
            entity.HasKey(e => e.IdTaux).HasName("PRIMARY");

            entity.ToTable("taux");

            entity.HasIndex(e => e.IdTypeCompte, "idTypeCompte");

            entity.Property(e => e.IdTaux)
                .HasColumnType("int(11)")
                .HasColumnName("idTaux");
            entity.Property(e => e.DateChangementTaux).HasColumnName("dateChangementTaux");
            entity.Property(e => e.IdTypeCompte)
                .HasColumnType("int(11)")
                .HasColumnName("idTypeCompte");
            entity.Property(e => e.Taux1)
                .HasPrecision(5, 4)
                .HasColumnName("taux");

            entity.HasOne(d => d.IdTypeCompteNavigation).WithMany(p => p.Tauxes)
                .HasForeignKey(d => d.IdTypeCompte)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("taux_ibfk_1");
        });

        modelBuilder.Entity<Typecompte>(entity =>
        {
            entity.HasKey(e => e.IdTypeCompte).HasName("PRIMARY");

            entity.ToTable("typecompte");

            entity.HasIndex(e => e.CodeType, "codeType").IsUnique();

            entity.Property(e => e.IdTypeCompte)
                .HasColumnType("int(11)")
                .HasColumnName("idTypeCompte");
            entity.Property(e => e.CodeType)
                .HasMaxLength(20)
                .HasColumnName("codeType");
            entity.Property(e => e.Description)
                .HasMaxLength(100)
                .HasColumnName("description");
        });

        modelBuilder.Entity<Typeoperation>(entity =>
        {
            entity.HasKey(e => e.IdTypeOperation).HasName("PRIMARY");

            entity.ToTable("typeoperation");

            entity.HasIndex(e => e.CodeOperation, "codeOperation").IsUnique();

            entity.Property(e => e.IdTypeOperation)
                .HasColumnType("int(11)")
                .HasColumnName("idTypeOperation");
            entity.Property(e => e.CodeOperation)
                .HasMaxLength(20)
                .HasColumnName("codeOperation");
            entity.Property(e => e.Description)
                .HasMaxLength(100)
                .HasColumnName("description");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}

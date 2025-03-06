{ config, ...}:
{
  config.security.krb5.settings = {
    realms = {
      "ECS.VUW.AC.NZ" = {
        admin_server = "ecs.vuw.ac.nz";
        kdc = ["krb2.ecs.vuw.ac.nz" "krb1.ecs.vuw.ac.nz"];
      };

      "STUDENT.VUW.AC.NZ" = {
        admin_server = "student.vuw.ac.nz";
        kdc = ["krb2.ecs.vuw.ac.nz" "krb1.ecs.vuw.ac.nz"];
      };

      domain_realm = {
        "ecs.vuw.ac.nz" = "ECS.VUW.AC.NZ";
        "student.vuw.ac.nz" = "STUDENT.VUW.AC.NZ";
      };
    };
    libdefaults = {
      default_realm = "ECS.VUW.AC.NZ";
      renew_lifetime = "7d";
    };
  };

  config.security.krb5.enable = true;
}

#import "@preview/modern-cv:0.7.0": *
#import "secrets.typ": andrew_phone_number

#show: resume.with(
  author: (
    firstname: "Andrew",
    lastname: "Jackson",
    email: "AndrewJackson2988@gmail.com",
    phone: andrew_phone_number,
    github: "AndrewJackson2020",
    linkedin: "andrew-jackson-410aab4b",
    address: "Forest Park, IL",
    positions: (
      "Software Engineer",
    ),
  ),
  date: datetime.today().display(),
  language: "en",
  colored-headers: true,
  show-footer: false,
)

= Experience

#resume-entry(
  title: "Database Engineer",
  location: "Chicago, IL",
  date: "Jan 2024 - Present",
  description: "Old Mission Capital",
)

#resume-item[
  - Architected firm-wide database infrastructure to enable migration of 30 scattered Postgres instances running on application servers onto centralized DBA managed platform
  - Acquired, configured, and maintained a fleet of 16 bare metal servers for databases and 4 VM's for etcd
  - Increased scalability of Postgres databases 400% by implementing connection pool layer allowing greater process sharing between clients
  - Wrote UI web app with python, flask and javascript to enable tenants and DBA's greater visibility into database operations across instances (open connections, idle transaction time, backup availability, etc)
  - Migrated scheduled maintenance jobs from disparate cron jobs on various machines to centralized scheduler platform enabling greater visibility and better integration with alerting platform
]

#resume-entry(
  title: "Lead Software Engineer",
  location: "Chicago, IL",
  date: "Aug 2022 - Dec 2023",
  description: "Enfusion",
)
#resume-item[
  - Led the creation of a software development team with the goal of increasing scalability of the analytics product line
  - Trained analytics team members in Python programming and software development best practices
  - Architected infrastructure on Google Cloud using Terraform and Docker to ensure reproducible software execution environments with dev/prod parity
  - Enabled cleanup of legacy SQL code-base by introducing Python based application layer delivered via REST API hosted on GCP and securely consumed by AWS based BI application
]


#resume-entry(
  title: "Software Engineer",
  location: "Downers Grove, IL",
  date: "Oct 2018 - Jul 2022",
  description: "Invesco",
)

#resume-item[
  - Developed R application utilizing the Axioma Portfolio Optimizer API to optimize portfolios and generate reporting and controls around re-balances which was used to manage 5\% of the firms Equity indexed strategy AUM
  - Wrote Python processes to automatically validate index files received from providers to ensure that index holdings comply with the index methodology
  - Designed data warehouse, reporting, and analytics application in Python to integrate index file data, fund position data, as well as market data from the Bloomberg and Factset
]

= Open Source

#resume-entry(
  title: "Pgbouncer",
  description: "Postgres connection pooler - C",
  location: [#github-link("pgbouncer/pgbouncer")],
)

#resume-item[
  - Fixed critical vulnerability that allowed pgbouncer to be susceptible from DDOS attacks
  - (Under Review) Implemented GSS Authentication to allow SSO via active directory
]

#resume-entry(
  title: "Postgres",
  description: "Relational Database - C",
  location: [#github-link("postgres/postgres")],
)

#resume-item[
  - (Under Review) Fixed outdated usage of LDAPv2 protocol in libpq preventing usage on some LDAP servers, including many slapd configurations
  - (Under Review) Implemented option to allow client to check all addresses within the given host for a valid connection
]

= Skills

#resume-skill-item(
  "Languages",
  (strong("Python"), "C", "Rust", "Go", "R"),
)
#resume-skill-item(
  "Databases",
  (strong("Postgres"), "BigQuery", "Mysql", "SQLite"),
)
#resume-skill-item(
  "Tools",
  ("Git", "Docker", "Podman", "Terraform", "Ansible", "GCP", "Jenkins", "Bazel"),
)
#resume-skill-item(
  "OS",
  (strong("RockyLinux"), strong("NixOS"), "ArchLinux", "Debian", "Windows"),
)

= Education

#resume-entry(
  title: "Northern Illiniois University",
  location: "Dekalb, IL",
  date: "May 2014",
  description: "B.S.",
)

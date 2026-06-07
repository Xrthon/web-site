
create table service_location_types (
    id bigint auto_increment primary key,

    code varchar(50) not null unique,

    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp on update current_timestamp
);

create table domain_categories (
    id bigint auto_increment primary key,

    code varchar(100) not null unique,

    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp on update current_timestamp
);

create table domains (
    id bigint auto_increment primary key,

    domain_category_id bigint not null,
    code varchar(50) not null unique,

    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp on update current_timestamp,

    constraint fk_domains_category
        foreign key (domain_category_id)
        references domain_categories(id)
        on delete restrict
);

-- client_need_statuses
	-- La table des status des besoins client sert a definir
  	-- les differents etats possible d'un besoin client
  	-- comme draft, active, completed ou cancelled
	-- cela permetera de centraliser et standardiser les status
	-- utiliser dans le systeme de gestion des besoins client
CREATE table client_need_statuses (
  id integer auto_increment primary key, 

  code varchar(50) not null unique,

  created_at timestamp default current_timestamp,
  updated_at timestamp default current_timestamp on update current_timestamp
);

-- client_needs:
	-- La table des besoins client sert a representer
	-- les demandes ou projets creer par un utilisateur
  	-- dans un domaine specifique comme electricite ou plomberie
	-- cela permetera a un client de decrire ses besoins
	-- afin de trouver des autonomes ou entreprises qualifiees
	-- pour realiser les travaux ou services demander
create table client_needs (
    id bigint auto_increment primary key,

    user_id bigint not null,
    domain_id bigint not null,
    client_need_status_id bigint not null,
    service_location_type_id bigint not null,

    title varchar(255) not null,

    city varchar(255),
    postal_code varchar(255),
    province varchar(255),

    budget_min decimal(10,2),
    budget_max decimal(10,2),

    desired_date date,

    is_urgent boolean not null default false,

    published_at timestamp null,

    created_at timestamp not null default current_timestamp,

    updated_at timestamp not null
        default current_timestamp
        on update current_timestamp,

    constraint fk_client_needs_user
        foreign key (user_id)
        references users(id)
        on delete cascade,

    constraint fk_client_needs_domain
        foreign key (domain_id)
        references domains(id)
        on delete restrict,

    constraint fk_client_needs_status
        foreign key (client_need_status_id)
        references client_need_statuses(id)
        on delete restrict,

    constraint fk_client_needs_service_type
        foreign key (service_location_type_id)
        references service_location_types(id)
        on delete restrict
);

create table domain_tasks (
    id bigint auto_increment primary key,

    domain_id bigint not null,

    code varchar(100) not null unique,

    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp on update current_timestamp,

    constraint fk_domain_tasks_domain
        foreign key (domain_id)
        references domains(id)
        on delete restrict
);

--client_need_items
	-- La table des elements de besoins client sert a decouper
  	-- un besoin client en plusieurs sous besoins ou taches
  	-- comme changer une prise ou installer un luminaire
	-- cela permetera de decrire plus precisement les travaux
	-- et services rechercher par le client
create table client_need_items (
    id bigint auto_increment primary key,

    client_need_id bigint not null,
    domain_task_id bigint null,

    title varchar(255) not null,
    description text,

    quantity int,

    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp on update current_timestamp,

    constraint fk_client_need_items_client_need
        foreign key (client_need_id)
        references client_needs(id)
        on delete cascade,

    constraint fk_client_need_items_domain_task
        foreign key (domain_task_id)
        references domain_tasks(id)
        on delete set null
);
--client_need_proposals
	-- A verifier avec le compte business et le compte travailleur autonome
--Table client_need_proposals {
  --id integer [primary key]

  --client_need_id integer
  --user_id integer

--  message text

  --estimated_price decimal

  --created_at timestamp
--}
--La table des domaines sert a definir
  --les differents secteurs de services disponible sur la plateforme
  --comme electricite, plomberie ou peinture
--cela permetera de centraliser et standardiser les domaines
-- utiliser dans les besoins client, autonomes et entreprises



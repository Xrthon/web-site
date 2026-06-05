
-- service_location_types:
	-- Look up pour savoir si l'intervention est a distance ou presentiel
Table service_location_types {
  id integer auto_increment primary key,

  code varchar not null  unique,

  created_at timestamp not null default current_timestamp,
  updated_at timestamp not null default current_timestamp on update current_timestamp
}

-- domain_categories:
	-- La table des domain_categories sert a definir
  	-- les types de categories pour englober plusieurs domain
Table domain_categories {
  id integer auto_increment primary key,

  code varchar(100) not null, unique

  created_at timestamp default current_timestamp,
  updated_at timestamp default current_timestamp on update current_timestamp
}

-- domains:
	-- La table des domains sert a definir
  	-- les types de domains qu'une categorie peu contenire
Table domains {
  id integer auto_increment primary key,

  domain_category_id integer not null, 
  code varchar(50) not null unique,

  created_at timestamp default current_timestamp,
  updated_at timestamp default current_timestamp on update current_timestamp,
  
  constraint fk_domains_category
  	foreign key (domain_category_id)
  	references domain_categories(id)
}

-- client_need_statuses
	-- La table des status des besoins client sert a definir
  	-- les differents etats possible d'un besoin client
  	-- comme draft, active, completed ou cancelled
	-- cela permetera de centraliser et standardiser les status
	-- utiliser dans le systeme de gestion des besoins client
Table client_need_statuses {
  id integer auto_increment primary key, 

  code varchar not null unique,

  created_at timestamp default current_timestamp,
  updated_at timestamp default current_timestamp on update current_timestamp
}

-- client_needs:
	-- La table des besoins client sert a representer
	-- les demandes ou projets creer par un utilisateur
  	-- dans un domaine specifique comme electricite ou plomberie
	-- cela permetera a un client de decrire ses besoins
	-- afin de trouver des autonomes ou entreprises qualifiees
	-- pour realiser les travaux ou services demander
Table client_needs {
  id bigint auto_increment primary key,

  user_id bigint not null,
  domain_id integer not null,
  client_need_status_id integer not null,  
  service_location_type_id integer [not null, ref: > service_location_types.id]

  title varchar [not null]

  city varchar
  postal_code varchar
  province varchar

  budget_min decimal
  budget_max decimal

  desired_date date
  is_urgent boolean [not null, default: false]

  published_at timestamp

  created_at timestamp
  updated_at timestamp
  
  constraint fk_client_needs_user 
  	foreign key (user_id)
  	references users(id)
  	on delete cascade,
  	
  constraint fk_client_needs_domain
  	foreign key (domain_id)
	references  domains(id),
	
  constraint fk_client_needs_status
  	foreign key (client_need_status_id)
  	references client_need_statuses(id),
  	
  	constraint fk_client_needs_service_type
  		foreign key (service_location_type_id)
  		references service_location_types(id)	
}

Table domain_tasks {
  id integer [primary key, increment]

  domain_id integer [not null, ref: > domains.id]

  code varchar [not null, unique]
  title varchar [not null]

  created_at timestamp
  updated_at timestamp
}
//La table des elements de besoins client sert a decouper
  //un besoin client en plusieurs sous besoins ou taches
  //comme changer une prise ou installer un luminaire
// cela permetera de decrire plus precisement les travaux
// et services rechercher par le client
Table client_need_items {
  id integer [primary key, increment]

  client_need_id integer [not null, ref: > client_needs.id]
  domain_type_id integer [ref: > domain_tasks.id]

  title varchar [not null]
  description text

  quantity integer

  created_at timestamp
  updated_at timestamp
}

// A verifier avec le compte business et le compte travailleur autonome
Table client_need_proposals {
  id integer [primary key]

  client_need_id integer
  user_id integer

  message text

  estimated_price decimal

  created_at timestamp
}
//La table des domaines sert a definir
  //les differents secteurs de services disponible sur la plateforme
  //comme electricite, plomberie ou peinture
// cela permetera de centraliser et standardiser les domaines
// utiliser dans les besoins client, autonomes et entreprises



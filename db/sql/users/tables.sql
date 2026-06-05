-- users: Table principale de notre utilisateur
	--	Obligatoire pour identifier un compte
create table users (
    id bigint auto_increment primary key,

    username varchar(50) not null unique,
    email varchar(255) not null unique,
	email_verified_at timestamp null,
	email_verification_token_hash CHAR(64) null unique,
    password_digest varchar(255) not null,

    is_active boolean not null default true,

    created_at timestamp not null default current_timestamp,

    updated_at timestamp not null default current_timestamp
        on update current_timestamp
);
-- file_categories:  Category de fichier --> look up (voir comment faire une look up bilingue)
create table file_categories (
    id bigint auto_increment primary key,

    code varchar(50) not null unique,

    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null
        default current_timestamp
        on update current_timestamp
);
-- user_files: rassemble toute les fichier de l'utilisateur 
create table user_files (
    id bigint auto_increment primary key,
    user_id bigint not null,
    file_category_id bigint not null,

    original_filename varchar(255) not null,
    stored_filename varchar(255) not null,

    mime_type varchar(100) not null,

    file_extension varchar(20),

    file_size bigint not null,

    storage_provider varchar(50) not null default 'local',

    storage_key text not null,

    checksum_sha256 char(64),

    is_private boolean not null default true,

    uploaded_by_ip varchar(45),

    created_at timestamp not null default current_timestamp,

    updated_at timestamp not null
        default current_timestamp
        on update current_timestamp,

    constraint fk_user_files_user
        foreign key (user_id)
        references users(id)
        on delete cascade,

    constraint fk_user_files_category
        foreign key (file_category_id)
        references file_categories(id)
        on delete restrict
);
-- user_profiles: Table de pour faire le profile de l'utilisateur
	--	element secondaire
create table user_profiles (
    id bigint auto_increment primary key,
    user_id bigint not null unique,
    profile_image_file_id bigint,

    first_name varchar(100) not null,
    last_name varchar(100) not null,
    display_name varchar(100) not null,

    phone varchar(30),
    birth_date date,

    bio text,

    language varchar(10) not null default 'fr',
    timezone varchar(255),

    country varchar(255) not null,
    city varchar(255) not null,

    address_line1 text not null,
    address_line2 text,

    postal_code varchar(20) not null,

    preferences json,
    ai_summary text,

    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp on update current_timestamp,

	constraint fk_user_profiles_profile_image_file
	    foreign key (profile_image_file_id)
	    references user_files(id)
	    on delete set null,

    constraint fk_user_profiles_user
        foreign key (user_id)
        references users(id)
        on delete cascade
);
-- user_email_verification_tokens: La table de verification des emails sert pour savoir 
	-- l’email existe réellement
	-- l’utilisateur possède cet email
	-- l’utilisateur peut recevoir des messages
	-- cela permetera de generer un token et puis de  valider la validiter du token 
create table user_email_verification_tokens (
    id bigint auto_increment primary key,

    user_id bigint not null,

    token_hash char(64) not null unique,

    expires_at timestamp not null,

    used_at timestamp null,

    created_at timestamp not null default current_timestamp,

    foreign key (user_id)
        references users(id)
        on delete cascade
);
-- user_password_resets: Une table pour le user_password_reset sert : 
	-- Invalider anciens tokens
	-- Garder un historique
	-- Limiter abus/spam
	-- Voir tentatives suspectes
create table user_password_resets (
    id bigint auto_increment primary key,

    user_id bigint not null,

    reset_token_hash char(64) not null unique,

    reset_sent_at timestamp not null default current_timestamp,
    reset_used_at timestamp null,
    expires_at timestamp not null,

    request_ip varchar(45),
    user_agent text,

    created_at timestamp not null default current_timestamp,

    updated_at timestamp not null
        default current_timestamp
        on update current_timestamp,

    constraint fk_user_password_resets_user
        foreign key (user_id)
        references users(id)
        on delete cascade
        
);
-- sessions: ici nous enregistrons les information de la sessions actuel de l'utilisateur 
create table sessions (
    id bigint auto_increment primary key,

    user_id bigint not null,

    session_token_hash char(64) not null unique,

    ip_address varchar(45),

    timezone varchar(255),

    user_agent text,

    os_name varchar(255),
    os_version varchar(255),

    browser_name varchar(255),
    browser_version varchar(255),

    device_type varchar(255),

    last_activity_at timestamp not null default current_timestamp,

    expires_at timestamp not null,

    revoked_at timestamp null,

    created_at timestamp not null default current_timestamp,

    updated_at timestamp not null
        default current_timestamp
        on update current_timestamp,

    constraint fk_user_sessions_user
        foreign key (user_id)
        references users(id)
        on delete cascade
);
-- user_login_histories: les événements de connexion
	-- historique permanent
create table user_login_histories (
    id bigint auto_increment primary key,

    user_id bigint null,
	attempted_email varchar(255),

    session_id bigint,

    login_at timestamp not null default current_timestamp,
    logout_at timestamp null,

    ip_address varchar(45),
    timezone varchar(255),

    user_agent text,

    os_name varchar(255),
    os_version varchar(255),

    browser_name varchar(255),
    browser_version varchar(255),

    device_type varchar(255),

    login_success boolean not null default true,

    failure_reason text,

    created_at timestamp not null default current_timestamp,

    constraint fk_user_login_histories_user
        foreign key (user_id)
        references users(id)
        on delete cascade,

    constraint fk_user_login_histories_session
        foreign key (session_id)
        references sessions(id)
        on delete set null
);
-- identity_verification_statuses: status de verification d'identite
create table identity_verification_statuses (
    id bigint auto_increment primary key,

    code varchar(50) not null unique,

    created_at timestamp not null default current_timestamp,

    updated_at timestamp not null
        default current_timestamp
        on update current_timestamp
);
-- identity_document_types: types de documents acceptes
create table identity_document_types (
    id bigint auto_increment primary key,

    code varchar(50) not null unique,

    created_at timestamp not null default current_timestamp,

    updated_at timestamp not null
        default current_timestamp
        on update current_timestamp
);
-- user_identity_verifications:  verification d'identite utilisateur
create table user_identity_verifications (
    id bigint auto_increment primary key,

    user_id bigint not null unique,

    identity_verification_status_id bigint not null,

    reviewed_by bigint,
    reviewed_at timestamp null,

    rejection_reason text,

    created_at timestamp not null default current_timestamp,

    updated_at timestamp not null
        default current_timestamp
        on update current_timestamp,

    constraint fk_user_identity_verifications_user
        foreign key (user_id)
        references users(id)
        on delete cascade,

    constraint fk_user_identity_verifications_status
        foreign key (identity_verification_status_id)
        references identity_verification_statuses(id)
        on delete restrict,

    constraint fk_user_identity_verifications_reviewed_by
        foreign key (reviewed_by)
        references users(id)
        on delete set null
);
-- user_identity_documents: documents d'identite utilisateur
create table user_identity_documents (
    id bigint auto_increment primary key,

    user_identity_verification_id bigint not null,

    identity_document_type_id bigint not null,

    file_front_id bigint not null,
    file_back_id bigint,

    expires_at date,

    created_at timestamp not null default current_timestamp,

    updated_at timestamp not null
        default current_timestamp
        on update current_timestamp,

    constraint fk_user_identity_documents_verification
        foreign key (user_identity_verification_id)
        references user_identity_verifications(id)
        on delete cascade,

    constraint fk_user_identity_documents_type
        foreign key (identity_document_type_id)
        references identity_document_types(id)
        on delete restrict,

    constraint fk_user_identity_documents_front_file
        foreign key (file_front_id)
        references user_files(id)
        on delete restrict,

    constraint fk_user_identity_documents_back_file
        foreign key (file_back_id)
        references user_files(id)
        on delete restrict
);
-- roles: lookup table pour les roles 
create table roles (
    id bigint auto_increment primary key,

    code varchar(50) not null unique,
    title varchar(100) not null unique,

    created_at timestamp not null default current_timestamp,

    updated_at timestamp not null
        default current_timestamp
        on update current_timestamp
);
-- user_roles: table de liaison pour les users et leur role
create table user_roles (
    id bigint auto_increment primary key,

    user_id bigint not null,
    role_id bigint not null,

    assigned_at timestamp not null default current_timestamp,

    created_at timestamp not null default current_timestamp,

    updated_at timestamp not null
        default current_timestamp
        on update current_timestamp,

    constraint uq_user_roles_user_role
        unique (user_id, role_id),

    constraint fk_user_roles_user
        foreign key (user_id)
        references users(id)
        on delete cascade,

    constraint fk_user_roles_role
        foreign key (role_id)
        references roles(id)
        on delete cascade
);


-- Historique : a continuer
create table user_role_histories (
    id bigint auto_increment primary key,

    user_id bigint not null,

    old_role_id bigint,
    new_role_id bigint not null,

    changed_by bigint,

    change_reason varchar(255),

    changed_at timestamp not null default current_timestamp,

    created_at timestamp not null default current_timestamp,

    constraint fk_user_role_histories_user
        foreign key (user_id)
        references users(id)
        on delete cascade,

    constraint fk_user_role_histories_old_role
        foreign key (old_role_id)
        references roles(id)
        on delete set null,

    constraint fk_user_role_histories_new_role
        foreign key (new_role_id)
        references roles(id)
        on delete restrict,

    constraint fk_user_role_histories_changed_by
        foreign key (changed_by)
        references users(id)
        on delete set null
);
create index idx_user_roles_user_id on user_roles(user_id);
create index idx_user_roles_role_id on user_roles(role_id);

create index idx_user_role_histories_user_id on user_role_histories(user_id);
create index idx_user_role_histories_changed_by on user_role_histories(changed_by);
create index idx_user_role_histories_changed_at on user_role_histories(changed_at);

create index idx_user_identity_verifications_status_id on user_identity_verifications(identity_verification_status_id);

create index idx_user_identity_documents_verification_id on user_identity_documents(user_identity_verification_id);
create index idx_user_identity_documents_type_id on user_identity_documents(identity_document_type_id);
create index idx_user_identity_documents_front_file_id on user_identity_documents(file_front_id);
create index idx_user_identity_documents_back_file_id on user_identity_documents(file_back_id);

create index idx_user_files_user_id on user_files(user_id);
create index idx_user_files_category_id on user_files(file_category_id);

create index idx_user_profiles_user_id on user_profiles(user_id);
create index idx_user_profiles_profile_image_file_id on user_profiles(profile_image_file_id);

create index idx_user_email_verification_tokens_user_id on user_email_verification_tokens(user_id);
create index idx_user_email_verification_tokens_expires_at on user_email_verification_tokens(expires_at);

create index idx_user_sessions_user_id on user_sessions(user_id);
create index idx_user_sessions_expires_at on user_sessions(expires_at);
create index idx_user_sessions_revoked_at on user_sessions(revoked_at);

create index idx_user_login_histories_user_id on user_login_histories(user_id);
create index idx_user_login_histories_session_id on user_login_histories(session_id);
create index idx_user_login_histories_login_at on user_login_histories(login_at);

create index idx_user_password_resets_user_id on user_password_resets(user_id);
create index idx_user_password_resets_expires_at on user_password_resets(expires_at);







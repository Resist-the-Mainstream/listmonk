package migrations

import (
	"log"

	"github.com/jmoiron/sqlx"
	"github.com/knadh/koanf/v2"
	"github.com/knadh/stuffbin"
)

// V3_1_0 performs the DB migrations.
func V3_1_0_RTM_0(db *sqlx.DB, fs stuffbin.FileSystem, ko *koanf.Koanf, lo *log.Logger) error {
	_, err := db.Exec(`
		CREATE INDEX IF NOT EXISTS rtm_campaign_views_idx ON bounces (campaign_id, subscriber_id);
		CREATE INDEX IF NOT EXISTS rtm_link_clicks_idx ON link_clicks (campaign_id, link_id, subscriber_id);
		CREATE INDEX IF NOT EXISTS rtm_bounces_idx ON bounces (campaign_id, subscriber_id);
	`)

	return err
}

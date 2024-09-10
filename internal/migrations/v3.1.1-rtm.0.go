package migrations

import (
	"log"

	"github.com/jmoiron/sqlx"
	"github.com/knadh/koanf/v2"
	"github.com/knadh/stuffbin"
)

// V3_1_1_RTM_0 performs the DB migrations.
func V3_1_1_RTM_0(db *sqlx.DB, fs stuffbin.FileSystem, ko *koanf.Koanf, lo *log.Logger) error {
	_, err := db.Exec(`
		CREATE INDEX IF NOT EXISTS rtm_idx_campaign_views_unique ON bounces (campaign_id, subscriber_id);
		CREATE INDEX IF NOT EXISTS rtm_idx_link_clicks_unique ON link_clicks (campaign_id, link_id, subscriber_id);
		CREATE INDEX IF NOT EXISTS rtm_idx_bounces_unique ON bounces (campaign_id, subscriber_id);
	`)

	return err
}

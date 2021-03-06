/**
 * 桌台相关的路由器
 */
const express = require('express')
const pool = require('../../pool')
var router = express.Router()
module.exports = router

/**
 * GET /admin/table
 * 获取所有的桌台信息
 * 返回数据：
 * 	[
 * 		{tid:xxx,tname:'xxx',status:''},
 * 		...
 * 	]
 */
router.get('/', (req, res) => {
	pool.query('SELECT * FROM xfn_table ORDER BY tid', (err, result) => {
		if (err) throw err;
		res.send(result);
	})
})
/**
* GET /admin/table
* 获取所有的桌台预定信息
*/
router.get('/reservation/:tid', (req, res) => {
	var $tid = req.params.tid;
	pool.query('SELECT * FROM xfn_reservation WHERE tableId=?', $tid, (err, result) => {
		if (err) throw err;
		res.send(result[0])
	})
})
/**
* GET /admin/table
* 获取所有的桌台占用信息
*/
router.get('/order/:tid', (req, res) => {
	var $tid = req.params.tid;
	var outputs = {
		order: {},
		order_detail: [],
		order_detail_dish_did: []
	}
	pool.query('SELECT * FROM xfn_order WHERE tableId=?', $tid, (err, result) => {
		if (err) throw err;
		outputs.order = result[0];
		if (result.length > 0) {
			var $oid = outputs.order.oid;
			if ($oid !== undefined) {
				pool.query('SELECT * FROM xfn_order_detail WHERE orderId=?', $oid, (err, result) => {
					if (err) throw err;
					outputs.order_detail = result;
					if(result.length==0){
							res.send({ code: 400, msg: 'error order' })
							return false;
					}else{
						for (let i = 0; i < result.length; i++) {
							outputs.order_detail_dish_did.push(outputs.order_detail[i].did);
						}
						res.send(outputs);
					}
				})
			}
		}
	})
})
// 占用桌台
router.put('/order/:tid', (req, res) => {
	var $tid = req.params.tid;
	var $tableInfos = req.body;
	console.log($tableInfos)
	pool.query('UPDATE xfn_table SET status=3 WHERE tid=?', $tid, (err, result) => {
		if (err) throw err;
		pool.query('REPLACE INTO xfn_order SET ?', $tableInfos, (err, result) => {
			if (err) throw err;
			if (result.affectedRows > 0) {
				res.send({ code: 200, msg: 'reserva added succ' })
			} else {
				res.send({ code: 400, msg: 'reserva added error' })
			}
		})
	})
})
// 预约桌台
router.put('/reservation/:tid', (req, res) => {
	var $tid = req.params.tid;
	var $tableInfos = req.body;
	pool.query('UPDATE xfn_table SET status=2 WHERE tid=?', $tid, (err, result) => {
		if (err) throw err;
		pool.query('REPLACE INTO xfn_reservation SET ?', $tableInfos, (err, result) => {
			if (err) throw err;
			if (result.affectedRows > 0) {
				res.send({ code: 200, msg: 'reserva added succ' })
			} else {
				res.send({ code: 400, msg: 'reserva added error' })
			}
		})
	})
})
// 空闲桌台
router.delete('/:tid', (req, res) => {
	var $tid = req.params.tid;
	var codes = {
		reservation: {},
		order: {}
	}
	pool.query('UPDATE xfn_table SET status=1 WHERE tid=?', $tid, (err, result) => {
		if (err) throw err;
		pool.query('DELETE FROM xfn_reservation WHERE tableId=?', $tid, (err, result) => {
			if (err) throw err;
			if (result.affectedRows > 0) {
				codes.reservation = { code: 200, msg: 'delete reserva succ' }
			} else {
				codes.reservation = { code: 400, msg: 'delete reserva error' }
			}
			pool.query('DELETE FROM xfn_order WHERE tableId=?', $tid, (err, result) => {
				if (err) throw err;
				if (result.affectedRows > 0) {
					codes.order = { code: 200, msg: 'delete order succ' }
				} else {
					codes.order = { code: 400, msg: 'delete order error' }
				}
				res.send(codes)
			})
		})
	})
})

// 其他桌台
router.put('/qitainfo/:tid', (req, res) => {
	var $tid = req.params.tid;
	pool.query('UPDATE xfn_table SET status=4 WHERE tid=?', $tid, (err, result) => {
		if (err) throw err;
		res.send({code:200,msg:'qitainfo table succ'})
	})
})
/**
 * post /admin/table/
 * 请求参数：{tid:null,tname:'xx',type:xx,status:'xx'}
 * 输出数据：
 * 	{code:200,msg:'table add succ'}
 * 	{code:400,msg:'table add error'}
 */
// 添加桌台
router.post('/',(req,res)=>{
	var $table = req.body;
	pool.query('INSERT INTO xfn_table SET ?',$table,(err,result)=>{
		if(err)throw err;
		if(result.affectedRows>0){
			res.send({code:200,msg:'table add succ'})
		}else{
			res.send({code:400,msg:'table add error'})
		}
	})
})

/**
 * DELETE /admin/table/:tableInfo
 * 根据指定的桌台编号或者名字删除该桌台
 * 输出数据：
 * 	{code:200,msg:'table deleted succ'}
 * 	{code:400,msg:'table not exists'}
 */
router.delete('/delTab/:tableInfo',(req,res)=>{
	var $tid = req.params.tableInfo;
	pool.query('DELETE FROM xfn_table WHERE tid=? OR tname=?',[$tid,$tid],(err,result)=>{
		if(err)throw err;
		if(result.affectedRows>0){
			res.send({code:200,msg:'table deleted succ'})
		}else{
			res.send({code:400,msg:'table deleted error'})
		}
	})
})